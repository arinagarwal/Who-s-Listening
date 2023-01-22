//
//  MonitorClasses.swift
//  Who's Listening?
//
//  Created by Arin on 1/2/23.
// Makes objects for monitors instead of including them in a seperate view

import Foundation
import AVFoundation
import UserNotifications
//Created using an observer object on a discovery session
class ObservedDiscoverySession: NSObject {
    @objc dynamic var discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInMicrophone, .builtInDualCamera, .builtInTripleCamera, .builtInTelephotoCamera, .builtInDualWideCamera, .builtInTrueDepthCamera, .builtInUltraWideCamera, .builtInWideAngleCamera],
            mediaType : nil,
            position : AVCaptureDevice.Position.unspecified
        )
}
//Observer for top class
class Observer: NSObject {
    private let notificationCenter = UNUserNotificationCenter.current()
    @objc var objectToObserve: ObservedDiscoverySession
    var observation: NSKeyValueObservation?
    
    init(object: ObservedDiscoverySession) {
        objectToObserve = object
        super.init()
        
        observation = observe(
            \.objectToObserve.discoverySession,
             options: [.old, .new]
        ) {object, change in
            self.sendNotification(title: "Device list has been changed", body: "Woah")
        }
    }
    
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: "microphone-in-use", content: content, trigger: nil)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
}

//Top two classes are one try at implementing
//Everything below does not produce the intended behavior
//________________________________________________________________________________________//



//chatGPT created **
class MicrophoneMonitor: NSObject {
    private let audioSession = AVAudioSession.sharedInstance()
    private let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()

        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                self.startMonitoring()
            }
        }
    }

    private func startMonitoring() {
            do {
                try audioSession.setActive(true)
                audioSession.addObserver(self, forKeyPath: "isInputAvailable", options: .new, context: nil)
            } catch {
                print("Error starting microphone monitoring: \(error.localizedDescription)")
            }
            
    }
    

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isInputAvailable", let isInputAvailable = change?[.newKey] as? Bool {
            if isInputAvailable {
                print("Device used!")
                sendNotification(title: "Microphone In Use", body: "An app is currently using the microphone.")
            }
        }
    }

    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: "microphone-in-use", content: content, trigger: nil)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
}

class CameraMonitor: NSObject {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                self.startMonitoring()
            }
        }
    }
    
    private func startMonitoring() {
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera, .builtInTripleCamera, .builtInTelephotoCamera, .builtInDualWideCamera, .builtInTrueDepthCamera, .builtInUltraWideCamera, .builtInWideAngleCamera],
            mediaType : nil,
            position : AVCaptureDevice.Position.unspecified
        )
        
        let captureDevices = discoverySession.devices
        for device in captureDevices {
            if device.hasMediaType(.video) {
                do {
                    try device.lockForConfiguration()
                    device.addObserver(self, forKeyPath: "videoZoomFactor", options: .new, context: nil)
                    device.unlockForConfiguration()
                } catch {
                    print("Error starting camera monitoring: \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isInputAvailable", let isInputAvailable = change?[.newKey] as? Bool {
            if isInputAvailable {
                sendNotification(title: "Camera In Use", body: "An app is currently using the camera.")
            }
        }
    }
    
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "microphone-in-use", content: content, trigger: nil)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
}

