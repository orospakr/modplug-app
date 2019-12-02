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

struct ContentView: View {
    @EnvironmentObject var player: ModPlugPlayer
    
    var body: some View {
        VStack {
            SocketedPlayerPanel(min10: 0, min: 0, sec10: 0, sec: 0).overlay(
                LCDText(text: player.title)
            )
//                .antialiased(false)
            Text("\(player.time)").font(.headline)
            HStack {
                Button(action: {
                    self.player.play()
                }, label: {
                    Text("play")
                })
                Image("play.fill")
                    .frame(width: 32, height: 32).foregroundColor(.red)
            }
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
