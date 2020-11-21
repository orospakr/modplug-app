//
//  LCDPixelArt.swift
//  ModPlug
//
//  Created by Andrew Clunis on 2019-12-01.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import SwiftUI
import CoreServices

struct LCDPixelArt: View {
    var body: some View {
        Image("MODPLUG.EXE_2_LCDSCREEN")
            .interpolation(.none)
    }
}

struct LCDSegmentedLargeNumbers: View {
    var body: some View {
        LCDPixelArt()
            .croppedTo(CGRect(
                x: 0, y: 42, width: 100, height: 18
            ))
    }
}

/// The alphabet arranged as per DOS code page 437. kTextEncodingDOSLatinUS / kCFStringEncodingDOSLatinUS / see CFStringEncodingExt.h
struct LCDAlphabet: View {
    var body: some View {
        LCDPixelArt()
            .croppedTo(CGRect(
                x: 0, y: 60, width: 320, height: 80
            ))
    }
}

struct LCDNumber: View {
    // Between 0 and 9
    let digit: Int
    
    var body: some View {
        LCDSegmentedLargeNumbers()
        .croppedTo(CGRect(
            x: digit * 10, y: 0, width: 10, height: 18
        ))
    }
}

struct StereoMono: View {
    var body: some View {
        LCDPixelArt()
            .croppedTo(CGRect(
                x: 100, y: 40, width: 28 * 2, height: 10
            ))
    }
}

struct PlayerPanel: View {
    var body: some View {
        LCDPixelArt()
            .croppedTo(CGRect(
                x: 0, y: 0, width: 408, height: 42
            ))
    }
}

struct SocketedPlayerPanel: View {
    let min10: Int
    let min: Int
    let sec10: Int
    let sec: Int
    
    var body: some View {
        PlayerPanel()
            .overlay(
                LCDNumber(digit: min10)
                    .padding(EdgeInsets(top: 11, leading: 3, bottom: 0, trailing: 0)),
                alignment: .topLeading
            )
            .overlay(
                LCDNumber(digit: min)
                    .padding(EdgeInsets(top: 11, leading: 3 + 10, bottom: 0, trailing: 0)),
                    alignment: .topLeading
            )
            .overlay(
                LCDNumber(digit: sec10)
                    .padding(EdgeInsets(top: 11, leading: 3 + 10 + 10 + 5, bottom: 0, trailing: 0)),
                    alignment: .topLeading
            )
            .overlay(
                LCDNumber(digit: sec)
                    .padding(EdgeInsets(top: 11, leading: 3 + 10 + 10 + 5 + 10, bottom: 0, trailing: 0)),
                    alignment: .topLeading
            )
    }
}

struct LCDPixelArt_Previews: PreviewProvider {    
    static var previews: some View {
        Group {
            SocketedPlayerPanel(min10: 1, min: 2, sec10: 3, sec: 4)
                .previewDisplayName("socketed panel")
            LCDPixelArt()
                .previewDisplayName("Entire LCD Bitmap")
            PlayerPanel()
                .previewDisplayName("Player Panel")
            LCDSegmentedLargeNumbers()
                .previewDisplayName("Large Segmented Numbers")
            LCDAlphabet()
                .previewDisplayName("Alphabet")
            LCDNumber(digit: 8)
                .previewDisplayName("Number 8")
            StereoMono()
                .previewDisplayName("Mono/Stereo")
//            letterPreview("a")
//            letterPreview("b")
            
//            letterPreview("å")
            
        }
        .previewLayout(.sizeThatFits)
    }
}
