//
//  DragHandle.swift
//  S3Snap
//
//  Created by Mr. Nafiz on 7/10/23.
//  Copyright © 2023 S3Snap.com. All rights reserved.
//

import Cocoa

let diameter:CGFloat = 40

class DragHandle: NSView {
    
    var fillColor = NSColor.darkGray
      var strokeColor = NSColor.lightGray
      var strokeWidth:CGFloat = 2.0
      
      required init(coder aDecoder: NSCoder) {
        fatalError("Use init(fillColor:, strokeColor:)")
      }
      
      init(fillColor:NSColor, strokeColor:NSColor, strokeWidth width:CGFloat = 2.0) {
        super.init(frame:CGRect(x: 0, y: 0, width: diameter, height: diameter))
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeWidth = width
        self.backgroundColor = NSColor.clear
      }
      
    override func draw(_ rect: CGRect)
    {
      super.draw(rect)
      let handlePath = NSBezierPath(ovalIn: rect.insetBy(dx: 10 + strokeWidth, dy: 10 + strokeWidth))
      fillColor.setFill()
      handlePath.fill()
      strokeColor.setStroke()
      handlePath.lineWidth = strokeWidth
      handlePath.stroke()
    }
    
}
