//
//  ContentView.swift
//  Who's Listening 2.0
//
//  Created by Arin on 1/15/23.
//

import SwiftUI
import AVFoundation
import UserNotifications


struct ContentView: View {
    @State private var microphonePermissionGranted: Bool = false
    @State private var notificationPermissionGranated: Bool = false
    var body: some View {
        VStack {
            if(!microphonePermissionGranted) {
                Button("Give mic Access") {
                    requestMicrophonePermission()
                }
                .padding(.bottom)
            }
            
            if(!notificationPermissionGranated) {
                Button("Allow notifications") {
                    requestNotificationAuthorization()
                }
                .padding(.bottom)
            }
        }
        .padding()
    }
    
    
    //Function called when access is to mic is requested
    private func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                microphonePermissionGranted.toggle()
            }
        }
    }
    
    //Function called to request authorization to notify
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
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
