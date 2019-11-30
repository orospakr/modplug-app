//
//  ContentView.swift
//  ModPlug
//
//  Created by Andrew Clunis on 2019-11-29.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import Combine
import SwiftUI
import CoreAudio
import AudioToolbox

class ModPlug: ObservableObject {
    func play() {
        let data: Data
        do {
//            data = try Data(contentsOf: URL(string: "file:///Users/andrew/DEADLOCK.XM")!)
            let path = Bundle.main.path(forResource: "DEADLOCK", ofType: "XM")!
            let url =  URL(fileURLWithPath: path)
           
            data = try Data(contentsOf: url)
        } catch {
            print(error)
            return
        }
        data.withUnsafeBytes { modData in
            let mpgFile = ModPlug_Load(modData.baseAddress, Int32(data.count))
            defer {
                print("Now freeing it.")
                ModPlug_Unload(mpgFile)
            }
            print("Mod file loaded!")
            
            var desc = AudioStreamBasicDescription(
                mSampleRate: 44100,
                mFormatID: kAudioFormatLinearPCM,
                mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
                mBytesPerPacket: 44100 * 2 * 2, // 1s of 11025 Hz, mono, 8-bit.
                mFramesPerPacket: 1,
                mBytesPerFrame: 44100 * 2 * 2,
                mChannelsPerFrame: 2,
                mBitsPerChannel: 16,
                mReserved: 0
            )
            
            var audioQueueRef: AudioQueueRef? = nil
            
            let result = AudioQueueNewOutput(
                &desc, // inFormat
                { (buffer, inAQ, inBuffer) in
                    // ModPlug_Read
                },
                nil, // user data
                nil, // cf runloop
                nil, // runloop mode
                0, // inFlags, must be 0.
                &audioQueueRef
            )
            
            guard result == 0 else {
                print("Audio format startup error code: \(result)")
                
//                NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osStatus userInfo:nil];
                let error = NSError(domain: NSOSStatusErrorDomain, code: Int(result), userInfo: nil)
                print("reason: \(error.description)")
                return
            }
            
            
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var player: ModPlug
    
    func weenis() {
        
    }
    
    var body: some View {
        Button(action: {
            self.player.play()
        }, label: {
            Text("Play")
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
