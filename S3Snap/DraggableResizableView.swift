//
//  DraggableResizableView.swift
//  AppKit Cocoa Resizable NSView
//
//  Created by Bibin Jacob Pulickal on 11/06/19.
//  Copyright © 2019 Bibin Jacob Pulickal. All rights reserved.
//

import Cocoa

class DraggableResizableView: NSView {

    private let resizableArea: CGFloat = 4
    private let borderPadding: CGFloat = 0
    private var draggedPoint: CGPoint  = .zero

    override init(frame frameRect: NSRect) {
        super.init(frame: CGRect(origin: frameRect.origin, size: CGSize(width: frameRect.width - 80, height: frameRect.height - 80)))
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { area in
            removeTrackingArea(area)
        }
        addTrackingRect(bounds)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        NSCursor.arrow.set()
        
        
        //topLeft.removeFromSuperview()
    }

    var topLeft:DragHandle!
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let locationInView = convert(event.locationInWindow, from: nil)
        draggedPoint            = locationInView
        print(" dragged point \(draggedPoint)")
        
//        let resizeFillColor = NSColor.cyan
//           let resizeStrokeColor = NSColor.black
//           let rotateFillColor = NSColor.orange
//           let rotateStrokeColor = NSColor.black
//           topLeft = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
//
//        self.addSubview(topLeft)
    }

    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        draggedPoint = .zero
    }

    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        let locationInView = convert(event.locationInWindow, from: nil)
        cursorBorderPosition(locationInView)
    }

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        
       dragMouse(event: event)
    }
    
    // MARK: Custom enum, func
    
    enum BorderPosition {
        case top, left, bottom, right, none
    }
    
    func dragMouse(event: NSEvent) {
        let locationInView              = convert(event.locationInWindow, from: nil)
        let horizontalDistanceDragged   = locationInView.x - draggedPoint.x
        let verticalDistanceDragged     = locationInView.y - draggedPoint.y
        let cursorPosition              = cursorBorderPosition(draggedPoint)
        if cursorPosition != .none {
            let drag    = CGPoint(x: horizontalDistanceDragged, y: verticalDistanceDragged)
            if checkIfBorder(cursorPosition, andDraggedOutward: drag) {
                return
            }
        }
        
        switch cursorPosition {
        case .top:
            size.height += verticalDistanceDragged
            draggedPoint = locationInView
        case .left:
            origin.x    += horizontalDistanceDragged
            size.width  -= horizontalDistanceDragged
        case .bottom:
            origin.y    += verticalDistanceDragged
            size.height -= verticalDistanceDragged
        case .right:
            size.width  += horizontalDistanceDragged
            draggedPoint = locationInView
        case .none:
            origin.x    += locationInView.x - draggedPoint.x
            origin.y    += locationInView.y - draggedPoint.y
        
            repositionView()
        }
    }

    @discardableResult
    func cursorBorderPosition(_ locationInView: CGPoint) -> BorderPosition {
        //print("local mouse dragged \(locationInView)")
        if locationInView.x < resizableArea {
            NSCursor.resizeLeftRight.set()
            return .left
        } else if locationInView.x > bounds.width - resizableArea {
            NSCursor.resizeLeftRight.set()
            return .right
        } else if locationInView.y < resizableArea {
            NSCursor.resizeUpDown.set()
            return .bottom
        } else if locationInView.y > bounds.height - resizableArea {
            NSCursor.resizeUpDown.set()
            return .top
        } else {
            NSCursor.arrow.set()
            return .none
        }
    }


    private func checkIfBorder(_ border: BorderPosition,
                               andDraggedOutward drag: CGPoint) -> Bool {
        if border == .left && frame.minX <= borderPadding && drag.x < 0 {
            return true
        }
        if border == .bottom && frame.minY <= borderPadding && drag.y < 0 {
            return true
        }
        guard let superView = superview else { return false }
        if border == .right && frame.maxX >= superView.frame.maxX - borderPadding && drag.x > 0 {
            return true
        }
        if border == .top && frame.maxY >= superView.frame.maxY - borderPadding && drag.y > 0 {
            return true
        }
        return false
    }

    private func repositionView() {
        if frame.minX < borderPadding {
            origin.x    = borderPadding
        }
        if frame.minY < borderPadding {
            origin.y    = borderPadding
        }
        guard let superView = superview else { return }
        
//        print("frame maxX \(frame.maxX) and frame maxY \(frame.maxY)")
//        print("super maxX \(superView.bounds.maxX) and super maxY \(superView.bounds.maxY)")
        
        if frame.maxX > superView.bounds.maxX - borderPadding {
            origin.x    = superView.bounds.maxX - frame.width - borderPadding
        }
        if frame.maxY > superView.bounds.maxY - borderPadding {
            origin.y    = superView.bounds.maxY - frame.height - borderPadding
        }
    }
}
