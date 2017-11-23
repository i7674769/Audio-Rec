//
//  ViewController.swift
//  Audio Rec
//
//  Created by Rebecca Hughes on 23/11/2017.
//  Copyright © 2017 Rebecca Hughes. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var recordingSession : AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var numberOfRecords: Int = 0
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func record(_ sender: Any)
    
    {
        //check if there is an active recorder
        if audioRecorder == nil
        {
         numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            //Start recording
            
            do {
                audioRecorder = try AVAudioRecorder (url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                
                
                buttonLabel.setTitle("Stop Recording", for: .normal)
            }
            catch
            {
                displayAlert(title: "Oop's!", message: "Recording Failed")
            }
        }
            else
        {
            //stop audio recording
                audioRecorder.stop()
                audioRecorder = nil
            
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            myTableView.reloadData()
            
                buttonLabel.setTitle("Start Recording", for: .normal)
                
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setting up session
        
        recordingSession = AVAudioSession.sharedInstance()
        
        if let number: Int = UserDefaults.standard.object(forKey: "myNumber") as? Int
        {
            numberOfRecords = number
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
        if hasPermission
        {
            print ("Accepted")
            }
        }
    }

   //Function that gets path to directory
    func getDirectory() -> URL
    {
        
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths [0]
        return documentDirectory
        
    }
//Func for alert
    func displayAlert(title:String, message:String)
    {
        
        let alert = UIAlertController (title: title, message: message, preferredStyle: .alert)
        alert.addAction (UIAlertAction (title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
//setting up table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView . dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String (indexPath.row + 1)
        return cell
    }
    
    //listen to recording
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        
        do {
            audioPlayer = try AVAudioPlayer (contentsOf: path)
            audioPlayer.play()
        }
        
        catch {
            
            
        }
    }
    
    
}

