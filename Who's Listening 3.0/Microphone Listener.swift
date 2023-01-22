//
//  Microphone Listener.swift
//  Who's Listening 3.0
//
//  Created by Arin on 1/18/23.
//

import Foundation
import UserNotifications
import AVFoundation
import UIKit

class MicrophoneListener {
    let audioSession = AVAudioSession.sharedInstance()
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    func startListening() {
        do {
            try audioSession.setActive(true)
            audioSession.addObserver(self as! NSObject, forKeyPath: "outputVolume", options: [.new], context: nil)
        } catch {
            print("Error starting microphone listener: \(error)")
        }
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
        checkMicrophone()
    }

    func stopListening() {
        audioSession.removeObserver(self as! NSObject, forKeyPath: "outputVolume")
        do{
           try audioSession.setActive(false)
        } catch {
            print("Could not set audio session to false")
        }
    }

    func checkMicrophone() {
        let currentRoute = audioSession.currentRoute
        if currentRoute.inputs.count > 0 {
            // Microphone is in use, send notification
            sendNotification()
        }
        // Schedule next check
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.checkMicrophone()
        }
    }

    func sendNotification() {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Microphone in use"
            content.body = "The microphone is currently being used"
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "microphone_in_use", content: content, trigger: trigger)
            center.add(request) { (error) in
                if let error = error {
                    print("Error sending notification: \(error)")
                }
            }
        }
    }
    





