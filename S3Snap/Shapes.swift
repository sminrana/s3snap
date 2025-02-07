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

struct ShapeAttributes {
    var lineWidth: Float
    var fillColor: NSColor
    var lineColor: NSColor
    var shapeFrame: NSRect
}

class Rectangle: DraggableResizableView, Shape {
    var lineWidth: Float
    var fillColor: NSColor
    var lineColor: NSColor
    var shapeFrame: NSRect
    
    init(attributes: ShapeAttributes) {
        self.lineWidth = attributes.lineWidth
        self.fillColor = attributes.fillColor
        self.lineColor = attributes.lineColor
        self.shapeFrame = attributes.shapeFrame
        
        super.init(frame: self.shapeFrame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // create a rectangle
        let rect = self.bounds

        // set the stroke and fill colors
        //NSColor.black.setStroke()
        self.lineColor.setStroke()

        // create a path and add the rectangle to it
        let path = NSBezierPath()
        path.appendRect(rect)
        path.lineWidth = CGFloat(self.lineWidth)
        
        // draw the path
        path.stroke()
    }
}


class FilledRectangle: DraggableResizableView, Shape {
    var lineWidth: Float
    var fillColor: NSColor
    var lineColor: NSColor
    var shapeFrame: NSRect
    
    init(attributes: ShapeAttributes) {
        self.lineWidth = attributes.lineWidth
        self.fillColor = attributes.fillColor
        self.lineColor = attributes.lineColor
        self.shapeFrame = attributes.shapeFrame
        
        super.init(frame: self.shapeFrame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // create a rectangle
        let rect = self.bounds

        self.lineColor.setFill()

        // create a path and add the rectangle to it
        let path = NSBezierPath()
        path.appendRect(rect)
        path.lineWidth = CGFloat(self.lineWidth)
        
        // draw the path
        path.fill()
    }
}

class Oval: DraggableResizableView, Shape {
    var lineWidth: Float
    var fillColor: NSColor
    var lineColor: NSColor
    var shapeFrame: NSRect
    
    init(attributes: ShapeAttributes) {
        self.lineWidth = attributes.lineWidth
        self.fillColor = attributes.fillColor
        self.lineColor = attributes.lineColor
        self.shapeFrame = attributes.shapeFrame
        
        super.init(frame: self.shapeFrame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // create a rectangle
        let rect = self.bounds

        self.lineColor.setStroke()

        // create a path and add the rectangle to it
        let path = NSBezierPath()
        path.appendOval(in: rect)
        path.lineWidth = CGFloat(self.lineWidth)
        path.flatness = 2.0
        
        // draw the path
        path.stroke()
    }
}

class FilledOval: DraggableResizableView, Shape {
    var lineWidth: Float
    var fillColor: NSColor
    var lineColor: NSColor
    var shapeFrame: NSRect
    
    init(attributes: ShapeAttributes) {
        self.lineWidth = attributes.lineWidth
        self.fillColor = attributes.fillColor
        self.lineColor = attributes.lineColor
        self.shapeFrame = attributes.shapeFrame
        
        super.init(frame: self.shapeFrame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // create a rectangle
        let rect = self.bounds

        self.lineColor.setFill()

        // create a path and add the rectangle to it
        let path = NSBezierPath()
        path.appendOval(in: rect)
        path.lineWidth = CGFloat(self.lineWidth)
        
        // draw the path
        path.fill()
    }
}

class FilledArrow: DraggableResizableView, Shape {
    var lineWidth: Float
    var fillColor: NSColor
    var lineColor: NSColor
    var shapeFrame: NSRect
    
    init(attributes: ShapeAttributes) {
        self.lineWidth = attributes.lineWidth
        self.fillColor = attributes.fillColor
        self.lineColor = attributes.lineColor
        self.shapeFrame = attributes.shapeFrame
        
        super.init(frame: self.shapeFrame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // create a rectangle
        let rect = self.bounds

        let pathArrow = NSBezierPath()
        let midX = rect.midX
        let midY = rect.midY
        let side = rect.width
        
        let dx = side * 0.15
        let offsetY = side * 0.1 + midY
        
        pathArrow.move(to: NSMakePoint(midX, offsetY - side/2))
        pathArrow.line(to: NSMakePoint(midX + dx, offsetY - side/2))
        pathArrow.line(to: NSMakePoint(midX + dx, offsetY + side * 0.05))
        pathArrow.line(to: NSMakePoint(midX + 2 * dx, offsetY + side * 0.05))
        pathArrow.line(to: NSMakePoint(midX, offsetY + side * 0.35))
        pathArrow.line(to: NSMakePoint(midX - 2 * dx, offsetY + side * 0.05))
        pathArrow.line(to: NSMakePoint(midX - dx, offsetY + side * 0.05))
        pathArrow.line(to: NSMakePoint(midX - dx, offsetY - side/2))
        pathArrow.close()
        
        //self.fillColor.setFill()
        pathArrow.fill()
    }
}


class ShapeFactory {
    enum ShapeType {
        case rectangle
        case filled_rectangle
        case oval
        case fileld_oval
        case text
        case arrow
    }
    
    static func createShape(type: ShapeType, shape: ShapeAttributes) -> NSView {
        switch type {
            case .rectangle:
                return Rectangle(attributes: shape)
            case .filled_rectangle:
                return FilledRectangle(attributes: shape)
            case .oval:
                return Oval(attributes: shape)
            case .fileld_oval:
                return FilledOval(attributes: shape)
            case .text:
                return FilledRectangle(attributes: shape)
            case .arrow:
                return FilledArrow(attributes: shape)
        }
    }
}


class ArrowView: DraggableResizableView {
    public var path: NSBezierPath = NSBezierPath()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSColor.black.set()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = 10.0
        path.stroke()
    }
    
    public func movePath(point: NSPoint) {
        path.move(to: point)
        needsDisplay = true
    }
    
    public func moveLine(point: NSPoint) {
        path.line(to: point)
        needsDisplay = true
    }
    
    override func mouseDown(with event: NSEvent) {
        //pointWhenMouseDown = convert(event.locationInWindow, from: nil)
        path.move(to: convert(event.locationInWindow, from: nil))
        needsDisplay = true
    }
//    
//    override func mouseUp(with event: NSEvent) {
//        //pointWhenMouseUp = convert(event.locationInWindow, from: nil)
//    }
//    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        path.line(to: convert(event.locationInWindow, from: nil))
        needsDisplay = true
    }
}
