//
//  ClassicPlayerWindow.swift
//  ModPlug Player
//
//  Created by Andrew Clunis on 2020-11-21.
//  Copyright © 2020 Andrew Clunis. All rights reserved.
//

import SwiftUI

struct ClassicPlayerWindow: View {
    @EnvironmentObject var player: ModPlugPlayer
    
    var body: some View {
        let time = player.positionSeconds
        let secs = time % 60
        let mins = time / 60
        
        let min = nThDigit(mins, digit: 1)
        let min10 = nThDigit(mins, digit: 2)
        let sec = nThDigit(secs, digit: 1)
        let sec10 = nThDigit(secs, digit: 2)
    
        return VStack {
            SocketedPlayerPanel(min10: min10, min: min, sec10: sec10, sec: sec).overlay(
                LCDText(text: (player.info?.title) ?? "")
            )
            HStack {
                Button(action: {
                    self.player.state = .stopped
                    self.player.state = .playing
                }, label: {
                    Text("Play").foregroundColor(
                        self.player.state == .playing ? Color.green : Color.primary
                    )
                })
                Button(action: {
                    self.player.state = .stopped
                }, label: {
                    Text("Stop").foregroundColor(
                        self.player.state == .stopped || self.player.state == .none ? Color.green : Color.primary
                    )
                })
            }
        }
        
           //  .frame(width: 418, height: 177) with spectrum analyzer
//            .frame(width: 418, height: 128)
    }
}

private func nThDigit(_ value: Int, digit n: Int) -> Int {
    // The nth digit is (the remainder of dividing by 10n) divided by 10n-1
    let n10 = NSDecimalNumber(decimal: (pow(10, n))).intValue
    let n10minus1 = NSDecimalNumber(decimal: (pow(10, (n - 1)))).intValue
    return (value % n10) / n10minus1
}
