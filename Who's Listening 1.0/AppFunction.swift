//
//  AppFunction.swift
//  Who's Listening?
//
//  Created by Arin on 12/31/22.
// This is a view that when running monitiors the mic and camera
//Problem is sending the notification, I suspect that the mic and camera aren't being constantly monitored

import SwiftUI
import UIKit
import UserNotifications
import AVFoundation




struct AppFunction: View {
    
    var body: some View {
        Button("Start Monitoring") {
            requestNotificationAuthorization()
            
            
            monitorMicrophoneAndCamera()
            //let y = ObservedDiscoverySession()
            //let x = Observer(object: y)
        }
  
    }
    
        //requests authorization to push notifications
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
        
    
    //This implementation is from chatGPT, and is the only one to successfully push a notification. However, it pushes the wrong notification every time. It also for some reason shows that several devices are connected when initially run and pushes one notification for the front camera being on, when it is not actually being used. Using other cameras/mic generates no notifications or print statements used for debug
    
        //function to monitor mic and camera, runs in background
        func monitorMicrophoneAndCamera() {
            
    
            
            
                let discoverySession = AVCaptureDevice.DiscoverySession(
                        //deviceTypes: [.builtInMicrophone, .builtInDualCamera, .builtInTripleCamera, .builtInTelephotoCamera, .builtInDualWideCamera, .builtInTrueDepthCamera, .builtInUltraWideCamera, .builtInWideAngleCamera],
                    deviceTypes: [.builtInMicrophone], 
                        mediaType : nil,
                        position : AVCaptureDevice.Position.unspecified
                    )
                    
                    let captureDevices = discoverySession.devices
            
            //Infinite loop not plausible for use. Takes up too much memory and ends up crashing app
                    
                
            while(true){
                        for device in captureDevices {
                            if device.hasMediaType(.audio) || device.hasMediaType(.video) {
                                if !device.isConnected {
                                    print("Device connected!") //debug
                                    sendNotification(device: device)
                                }
                            }
                        }
                }
                 
        }
        //func that pushes notification when camera or mic becomes in use
        //Called from monitorMicrophoneAndCamera
        func sendNotification(device: AVCaptureDevice) {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Device Connected"
            content.body = "The \(device.localizedName) has been connected."
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (2),
                                                            repeats: false)
            
            let request = UNNotificationRequest(identifier: "notification-request", content: content, trigger: trigger)
            
            
            center.add(request) { (error) in
                if let error = error {
                    print("Notification Error: ", error)
                }
            }
        }
    }
    
    struct AppFunction_Previews: PreviewProvider {
        static var previews: some View {
            AppFunction()
        }
    }

