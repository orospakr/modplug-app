//
//  ContentView.swift
//  ModPlug
//
//  Created by Andrew Clunis on 2019-11-29.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import Combine
import SwiftUI

struct LcdPanelItem: View {
    var rect: CGRect
    
    var body: some View {
        Image("MODPLUG.EXE_2_LCDSCREEN")
        .interpolation(.none)
        .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -70))
        .clipped()
    }
}

private func nThDigit(_ value: Int, digit n: Int) -> Int {
    // The nth digit is (the remainder of dividing by 10n) divided by 10n-1
    let n10 = NSDecimalNumber(decimal: (pow(10, n))).intValue
    let n10minus1 = NSDecimalNumber(decimal: (pow(10, (n - 1)))).intValue
    return (value % n10) / n10minus1
}

struct ContentView: View {
    @EnvironmentObject var player: ModPlugPlayer
    
    var body: some View {
        let time = Int(player.time / 1000)
        let secs = time % 60
        let mins = time / 60
        
        let min = nThDigit(mins, digit: 1)
        let min10 = nThDigit(mins, digit: 2)
        let sec = nThDigit(secs, digit: 1)
        let sec10 = nThDigit(secs, digit: 2)
    
        return VStack {
            SocketedPlayerPanel(min10: min10, min: min, sec10: sec10, sec: sec).overlay(
                LCDText(text: player.title)
            )
//                .antialiased(false)
            Button(action: {
                self.player.play()
            }, label: {
                Text("play")
            })
        }
           //  .frame(width: 418, height: 177) with spectrum analyzer
//            .frame(width: 418, height: 128)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ModPlugPlayer())
    }
}
