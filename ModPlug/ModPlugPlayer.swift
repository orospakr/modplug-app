//
//  ModPlug.swift
//  ModPlug
//
//  Created by Andrew Clunis on 2019-11-30.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import Foundation
import Combine
import AVFoundation

class ModPlugPlayer: ObservableObject {
    var engine: AVAudioEngine?
    
    /// Current time in seconds.
    @Published var time: Double = 0
    
    @Published var title: String = ""
    
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
//            defer {
//                print("Now freeing it.")
//                ModPlug_Unload(mpgFile)
//            }
            print("Mod file loaded!")
            
            let maxLengthSeconds = ModPlug_GetLength(mpgFile)
            let maxPos = ModPlug_GetMaxPosition(mpgFile)
            
            // seconds consumed per pos.
            let posTime: Double = Double(maxLengthSeconds) / Double(maxPos)
            
            
            self.title = String(cString: ModPlug_GetName(mpgFile))
            
            let inputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 2, interleaved: true)!
            
            let engine = AVAudioEngine()
            self.engine = engine
            let mainMixer = engine.mainMixerNode
            
            let output = engine.outputNode
            let format = output.inputFormat(forBus: 0)

            // create an output format that matches what the output device expects.
            let outputFormat = AVAudioFormat(commonFormat: format.commonFormat,
                                            sampleRate: format.sampleRate,
                                            channels: 2,
                                            interleaved: format.isInterleaved)!
            
            let source = AVAudioSourceNode(format: inputFormat) { (silence, time, frameCount, bufferList) -> OSStatus in
                let ablPointer = UnsafeMutableAudioBufferListPointer(bufferList)
                for buffer in ablPointer {
                    // TODO: check read size result?
                    ModPlug_Read(mpgFile, buffer.mData, Int32(buffer.mDataByteSize))
                }
                
                // TODO side-effect: dispatch time update.
                let currentPosition = ModPlug_GetCurrentPos(mpgFile)
                DispatchQueue.main.async {
                    // TODO: this time calculation is very approximate, and shows noticable artifacts as tempo changes occur. better to dead-reckon time using audio playback from latest seek-or-start event.
                    self.time = Double(currentPosition) * posTime
                }
                
                return noErr
            }
            
            engine.attach(source)

            engine.connect(source, to: mainMixer, format: outputFormat)
            engine.connect(mainMixer, to: engine.outputNode, format: nil)
            mainMixer.outputVolume = 0.5
            
        
            try! engine.start()
        }
    }
}
