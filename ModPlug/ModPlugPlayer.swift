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

enum PlayerState {
    case none
    case playing
    case paused
    case stopped
}

struct ModfileInfo {
    var title: String
    var lengthSeconds: Double
}

class ModPlugPlayer: ObservableObject {
    /// Only visible in relevant states.
    @Published var info: ModfileInfo?
    
    /// Current time in seconds.
    @Published var positionSeconds: Double = 0

    private var engine: AVAudioEngine?
    
    /// File to open (next time going from none to stopped)
    var currentFile: URL?
    
    private var modplugFile: OpaquePointer? // Type ModPlugFile, see modplug.h
    
    @Published public var state: PlayerState = .none {
        // How do I handle async state transitions, like loading? also I want to hide the State from consumer so that needs action methods.
                       
       // at some point, maybe I do just want to use composable architecture for a better async story.  Also that would allow constraining certain state values to only be available in certain states, rather than optionals. also I have a bit of a semantic differences between the states and the "actions" i want to bring us to those states.
        willSet {
            switch (state, newValue) {
            case (.none, .stopped):
                guard let currentFile = self.currentFile else {
                    return
                }
                load(url: currentFile)
            case (.stopped, .playing):
                play()
            case (.playing, .stopped):
                engine?.stop()
                ModPlug_Seek(modplugFile, 0)
            case (.playing, .none):
                engine?.stop()
                self.modplugFile = nil
                self.info = nil
            default:
                // be nice and allow no-ops.
                if state != newValue {
                    assertionFailure("Unsupported transition: \((state, newValue))")
                }
            }
        }
    }
    
    private func load(url: URL) {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            print(error)
            return
        }
        data.withUnsafeBytes { modData in
            // I think I am using memory here that I am not entitled to out of scope of this withUnsafeBytes (I don't think it is copied).
            // if so, wrap both the opaquepointer and a copy of the file's memory in a struct.
            let mpgFile = ModPlug_Load(modData.baseAddress, Int32(data.count))
//            defer {
//                print("Now freeing it.")
//                ModPlug_Unload(mpgFile)
//            }
            print("Mod file loaded!")
            

            
            // seconds consumed per pos.
            

            self.info = ModfileInfo(
                title: String(cString: ModPlug_GetName(mpgFile)),
                lengthSeconds: Double(ModPlug_GetLength(mpgFile))
            )
            
            self.modplugFile = mpgFile
        }
    }
    
    deinit {
        engine?.stop()
    }
    
    private func play() {
        guard let modplugFile = self.modplugFile else {
            return
        }
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
        
        let maxLengthSeconds = ModPlug_GetLength(modplugFile)
        let maxPos = ModPlug_GetMaxPosition(modplugFile)
        
        let posTime: Double = Double(maxLengthSeconds) / Double(maxPos)
        
        let source = AVAudioSourceNode(format: inputFormat) { [weak self] (silence, time, frameCount, bufferList) -> OSStatus in
            guard let self = self else {
                // Really should cancel here, but we're stopping() the player elsewhere.
                return noErr
            }
            let ablPointer = UnsafeMutableAudioBufferListPointer(bufferList)
            for buffer in ablPointer {
                // TODO: check read size result?
                ModPlug_Read(modplugFile, buffer.mData, Int32(buffer.mDataByteSize))
            }
            
            // TODO side-effect: dispatch time update.
            let currentPosition = ModPlug_GetCurrentPos(modplugFile)
            DispatchQueue.main.async {
                // TODO: this time calculation is very approximate, and shows noticable artifacts as tempo changes occur. better to dead-reckon time using audio playback from latest seek-or-start event.
                self.positionSeconds = Double(currentPosition) * posTime
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
