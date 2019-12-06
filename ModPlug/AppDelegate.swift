//
//  AppDelegate.swift
//  ModPlug
//
//  Created by Andrew Clunis on 2019-11-29.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var player = ModPlugPlayer()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let contentView = ContentView()
          .environmentObject(player)

        // Create the window and set the content view.
        let window = NSWindow(
          contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
          styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
          backing: .buffered, defer: false
        )
        window.center()
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension NSApplication {
    static var appDelegate: AppDelegate {
        NSApplication.shared.delegate! as! AppDelegate
    }
}
