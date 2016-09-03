//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by JODIE PARKER on 01/09/2016.
//  Copyright © 2016 urbanshed. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var recordedAudioURL:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.enabled = false
    }
    
    func updateRecordingButton(recording: Bool) {
        print(recording)
        recordingLabel.text = recording ? "Recording in Progress" : "Tap to Record"
        stopRecordingButton.enabled = recording
        recordButton.enabled = !recording
    }

    @IBAction func recordAudio(sender: AnyObject) {
        print("record button was pressed")
        updateRecordingButton(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! recordedAudioURL = AVAudioRecorder(URL: filePath!, settings: [:])
        recordedAudioURL.delegate = self
        recordedAudioURL.meteringEnabled = true
        recordedAudioURL.prepareToRecord()
        recordedAudioURL.record()
        
    }

    @IBAction func stopRecording(sender: AnyObject) {
        updateRecordingButton(false)
        recordedAudioURL.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if (flag) {
            performSegueWithIdentifier("stopRecording", sender: recordedAudioURL.url)
        } else {
            print("Did not record")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
   
}

