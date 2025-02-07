/**
 * ***********************************************************************
 *  S3 Snap CONFIDENTIAL
 *   __________________
 *
 * Copyright 2022 S3 Snap
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of S3 Snap and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to S3 Snap
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from S3 Snap.
 * www.s3snap.com
 *
 */

import Cocoa

class ImageEditingView: NSView {
    public var delegate: GettingMouseEvents?
    
    public var image: NSImage?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if let img = self.image {
            let frame = NSRect(origin: CGPoint(x: 0, y: 0), size: img.size)
            
            if let context = NSGraphicsContext.current?.cgContext {
               img.draw(in: frame , from: NSRect.zero, operation: .sourceOver, fraction: 1.0)
            }
        }
        
//        NSColor.black.set()
//        testView.path.lineJoinStyle = .round
//        testView.path.lineCapStyle = .round
//        testView.path.lineWidth = 10.0
//        testView.path.stroke()
        
        //testView.setNeedsDisplay(self.bounds)
    }
    
    override func mouseDown(with event: NSEvent) {
        //pointWhenMouseDown = convert(event.locationInWindow, from: nil)
//        self.testView = TestView()
//        self.testView?.frame = NSRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.width - 80, height: self.bounds.height - 80))
//        self.addSubview(self.testView!)
//        self.testView?.path.move(to: convert(event.locationInWindow, from: nil))
//        self.testView?.needsDisplay = true
        
        if let d = self.delegate {
           d.onMouseDown(point: convert(event.locationInWindow, from: nil))
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        //pointWhenMouseUp = convert(event.locationInWindow, from: nil)
        //self.testView?.frame = NSRect(origin: NSPoint(x: 190, y: 190), size: CGSize(width: 300, height: 300))
        //self.testView?.frame = NSRect(origin: self.bounds.origin, size: CGSize(width: 600, height: 600))
        //self.testView?.needsDisplay = true
        
        if let d = self.delegate {
           d.onMouseUp(point: convert(event.locationInWindow, from: nil))
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
//        self.testView?.path.line(to: convert(event.locationInWindow, from: nil))
//        self.testView?.needsDisplay = true
        
        let locationInView = convert(event.locationInWindow, from: nil)
        if let d = self.delegate {
            d.onMouseDrag(point: locationInView)
        }
    }
}

protocol GettingMouseEvents {
    func onMouseDown(point: NSPoint);
    func onMouseUp(point: NSPoint);
    func onMouseDrag(point: NSPoint);
}

class TestView: NSView {
    var startPoint: NSPoint?
    var endPoint: NSPoint?
    
    public var path: NSBezierPath = NSBezierPath()
    
    override init(frame frameRect: NSRect) {
                    super.init(frame:frameRect);
        //self.backgroundColor = NSColor.red
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if let startPoint = startPoint, let endPoint = endPoint {
            let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x) + CGFloat.pi
            let arrowLength: CGFloat = 20
            
            print(" angle>> \(angle)")
            print(" pi/4>> \(CGFloat.pi/4)")
            print(" cos>> \(cos(angle - .pi/4))")
            print(" sin>> \(sin(angle - .pi/4))")
            
            let linePath = NSBezierPath()
            linePath.move(to: startPoint)
            
            // TODO: Not required
//            let angle2 = atan2(endPoint.y, endPoint.x) + CGFloat.pi
//            let p = CGPoint(
//                x: endPoint.x - cos(angle - .pi/4),
//                y: endPoint.y - sin(angle - .pi/4)
//            )
            
            linePath.line(to: endPoint)
            
            NSColor.red.setStroke()
            linePath.lineWidth = 5.0
            linePath.stroke()
            //linePath.close()
            
            let arrowheadPath = NSBezierPath()
           
            let p = CGPoint(
                x: endPoint.x - cos(angle - .pi/4),
                y: endPoint.y - sin(angle - .pi/4)
                
            )
            
            //arrowheadPath.move(to: p)
            arrowheadPath.move(to: endPoint)
            
            let x1 = endPoint.x + arrowLength * cos(angle - .pi/4);
            print(" x1>> \(x1)")
            let arrowPoint1 = CGPoint(x: x1, y: endPoint.y + arrowLength * sin(angle - .pi/4))
            let arrowPoint2 = CGPoint(x: endPoint.x + arrowLength * cos(angle + .pi/4), y: endPoint.y + arrowLength * sin(angle + .pi/4))
            
            arrowheadPath.line(to: arrowPoint1)
            arrowheadPath.line(to: arrowPoint2)

            NSColor.black.setFill()
            arrowheadPath.fill()
            
            
            //arrowheadPath.close()
        }
    }
}
