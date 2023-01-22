//
//  ViewController.swift
//  Who's Listening?
//
//  Created by Arin on 12/30/22.
//

import UIKit
import UserNotifications
import AVFoundation
import BackgroundTasks

class ViewController: UIViewController {
    
    private var micPermission: Bool = false
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up a notification for when the microphone is turned on
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(microphoneWasTurnedOn),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)
        
        //request authorization to send notifiactions
        requestNotificationAuthorization()
        
        //request authorization to use the mic
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                self.micPermission.toggle()
            }
        }
        
        //Sets up a background task
        
        }
        // Set up a periodic timer to check the microphone status
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.checkMicrophoneStatus()
        }
    }
    
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
    
    @objc func microphoneWasTurnedOn() {
        // Send a notification to the user
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Microphone turned on"
        content.body = "The microphone was turned on by an app."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (2),
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification-request", content: content, trigger: trigger)
        
        
        center.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
        
        func checkMicrophoneStatus() {
            // Check the current microphone status
            do {
                let audioInputs = audioSession.currentRoute.inputs
                let microphoneInput = audioInputs.first(where: { input in
                    input.portType == AVAudioSession.Port.builtInMic
                })
                if microphoneInput != nil {
                    // The microphone is currently active
                    microphoneWasTurnedOn()
                }
            }
        }
}
