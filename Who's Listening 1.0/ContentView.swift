//
//  ContentView.swift
//  Who's Listening?
//
//  Created by Arin on 12/23/22.
//

import SwiftUI
import AVFoundation
import UIKit
import UserNotifications
import BackgroundTasks

struct ContentView: View {
    @State private var microphonePermissionGranted: Bool = false
    @State private var cameraPermissionGranted: Bool = false
    
    var body: some View {
 
        VStack{
            
            Text("Welcome")
                    .font(.title)
                    .fontWeight(.bold)
            
            //Button that gives user option to give access to cam/ mic
            if (!microphonePermissionGranted || !cameraPermissionGranted) {
                    Text("To use this app, you must give us access to the microphone and camera")
                            .padding(.horizontal)
                            .padding(.bottom)
                    
                    Button("Give Microphone Access") {
                            requestMicrophonePermission()
                        }
                    .padding(.bottom)
                
                    Button("Give Camera Access") {
                        requestCameraPermission()
                    }
                    .padding(.bottom)
                }
            //Message printed once necessary permissions are granted
            if (microphonePermissionGranted && cameraPermissionGranted) {
                Text("We will send you a notification when someone")
                    .padding(.horizontal)
                Text("turns on your mic or camera!")
                    .padding(.horizontal)
                    .padding(.bottom)
                
                AppFunction()
                //var MicMon = MicrophoneMonitor()
                //var CamMon = CameraMonitor()
            }

        }
        
       
        

  
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.micMonitorT")
        try? BGTaskScheduler.shared.submit(request)
    }
    
    //Function called when access is to mic is requested
    private func requestMicrophonePermission() {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    microphonePermissionGranted.toggle()
                }
            }
        }
    
    //Function called when access to camera is requested
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                cameraPermissionGranted.toggle()
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



