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

class ResizableView: NSView {

    private let resizableArea   = CGFloat(2)
    private var draggedPoint    = CGPoint.zero

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        backgroundColor = .red
        borderColor     = .white
        borderWidth     = resizableArea
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { area in
            removeTrackingArea(area)
        }
        addTrackingRect(bounds)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        NSCursor.arrow.set()
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let locationInView = convert(event.locationInWindow, from: nil)
        draggedPoint            = locationInView
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
        borderWidth                     = resizableArea
        let locationInView              = convert(event.locationInWindow, from: nil)
        let horizontalDistanceDragged   = locationInView.x - draggedPoint.x
        let verticalDistanceDragged     = locationInView.y - draggedPoint.y
        let cursorPosition              = cursorBorderPosition(draggedPoint)
        if cursorPosition != .none {
            let drag    = CGPoint(x: horizontalDistanceDragged, y: verticalDistanceDragged)
            if checkIfBorder(cursorPosition, exceedsSuperviewBorderWithPadding: 12, andDraggedOutward: drag) {
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
            break
        }
    }

    @discardableResult
    func cursorBorderPosition(_ locationInView: CGPoint) -> BorderPosition {
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
                               exceedsSuperviewBorderWithPadding padding: CGFloat,
                               andDraggedOutward drag: CGPoint) -> Bool {
        if border == .left && frame.minX <= padding && drag.x < 0 {
            return true
        }
        if border == .bottom && frame.minY <= padding && drag.y < 0 {
            return true
        }
        guard let superView = superview else { return false }
        if border == .right && frame.maxX >= superView.frame.maxX - padding && drag.x > 0 {
            return true
        }
        if border == .top && frame.maxY >= superView.frame.maxY - padding && drag.y > 0 {
            return true
        }
        return false
    }

    enum BorderPosition {
        case top, left, bottom, right, none
    }
}
