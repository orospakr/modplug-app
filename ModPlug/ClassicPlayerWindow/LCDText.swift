//
//  LCDText.swift
//  ModPlug
//
//  Created by Andrew Clunis on 2019-12-01.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import SwiftUI


struct LCDLetterIndexed: View {
    var xPosition: Int
    var yPosition: Int
    
    var body: some View {
        LCDAlphabet()
                .croppedTo(CGRect(x: 10 * ( xPosition ), y: 20 * yPosition, width: 10, height: 20))
    //        return Text(String(format:"0x%02X", letterIndex))
    }
}

struct LCDLetter: View {
    var letter: String
    
    var body: some View {
        let _kCFStringEncodingDOSLatinUS = UInt32(0x0400)    /* code page 437 */
        let nsencoding = CFStringConvertEncodingToNSStringEncoding(_kCFStringEncodingDOSLatinUS)
        
        let str = NSString(string: letter)
        let data = str.data(using: nsencoding)!
        
        // there's my number!
        let cp437Number = data.first!
        let haxVal = String(format:"0x%02X", cp437Number)
        if letter.count != 1 {
            assertionFailure("LCDLetter must receive 1 letter.")
        }
//        return Text(haxVal)
        let yRow = (cp437Number / 32) - 1
        let xRow = cp437Number % 32
//        let letterIndex =  Int(cp437Number - 0x080)
        
        return LCDLetterIndexed(xPosition: Int(xRow), yPosition: Int(yRow))
//        return Text(String(format:"0x%02X", letterIndex))
    }
}

struct LCDText: View {
    /// Only use characters that are ultimately valid in CP437 (basically latin-1-like characters).
    var text: String
    var body: some View {
        let enumeration = Array(text.enumerated())
        return HStack(spacing: 0) {
            ForEach(enumeration, id: \.offset) { character in
                return LCDLetter(letter: String(character.element))
            }
        }
    }
}

struct LCDText_Previews: PreviewProvider {
    static func letterPreview(_ letter: String) -> some View {
        HStack {
            LCDLetter(letter: letter)
        }
        .previewDisplayName("Letter \(letter)")
    }
    
    static var previews: some View {
        Group {
            LCDText(text: "Hi.  Welcome to ModPlug.")
        }
    }
}
