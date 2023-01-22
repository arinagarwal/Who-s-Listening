//
//  Who_s_Listening_2_0App.swift
//  Who's Listening 2.0
//
//  Created by Arin on 1/15/23.
//


//HOW TO MAKE APP WAKE IN THE BACKGROUND WHEN MIC IS TURNED ON

import SwiftUI
import BackgroundTasks
import AVFoundation

@main
struct Who_s_Listening_2_0App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .backgroundTask(.appRefresh("com.micMon")){
            scheduleAppRefresh()
            if checkMicrophoneStatus(){
                microphoneWasTurnedOn()
            }
        }
    }
      
}

func scheduleAppRefresh() {
    let date = Date()
    let nextDate = date.addingTimeInterval(10)
    let request = BGAppRefreshTaskRequest(identifier: "com.micMon")
    request.earliestBeginDate = nextDate
    try? BGTaskScheduler.shared.submit(request)
}

func checkMicrophoneStatus() -> Bool{
    // Check the current microphone status
    let audioSession = AVAudioSession.sharedInstance()
    do {
        let audioInputs = audioSession.currentRoute.inputs
        let microphoneInput = audioInputs.first(where: { input in
            input.portType == AVAudioSession.Port.builtInMic
        })
        if microphoneInput != nil {
            // The microphone is currently active
            microphoneWasTurnedOn()
            return true
        }
        
        return false
    }
}

func microphoneWasTurnedOn() {
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
