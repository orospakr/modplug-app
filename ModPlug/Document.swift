//
//  Document.swift
//  ModPlug Player
//
//  Created by Andrew Clunis on 2019-12-03.
//  Copyright © 2019 Andrew Clunis. All rights reserved.
//

import Cocoa
import SwiftUI

class Document: NSDocument {
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Using an SDI arrangement, so not making a View Controller here.
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override read(from:ofType:) instead.
        // If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
        
        NSApplication.appDelegate.player.state = .none
        NSApplication.appDelegate.player.currentFile = data
        NSApplication.appDelegate.player.state = .stopped
        NSApplication.appDelegate.player.state = .playing
        
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
}
