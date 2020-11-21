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
    var body: some View {
        ClassicPlayerWindow()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ModPlugPlayer())
    }
}
