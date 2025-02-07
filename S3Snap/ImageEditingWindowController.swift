//
//  ImageEditingWindowController.swift
//  glorious-osx
//
//  Created by nafiz on 3/4/23.
//  Copyright © 2023 Oliver Schneider. All rights reserved.
//

import Cocoa

class ImageEditingWindowController: NSWindowController {

    convenience init() {
        self.init(windowNibName: "ImageEditingWindowController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
