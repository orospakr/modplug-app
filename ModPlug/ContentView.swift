//
//  ContentView.swift
//  ModPlug
//
//  Created by Andrew Clunis on 2019-11-29.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import Combine
import SwiftUI

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
