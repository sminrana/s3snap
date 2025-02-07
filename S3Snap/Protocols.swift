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

import Foundation
import Cocoa

protocol Shape {
    var lineWidth: Float { get set }
    var fillColor: NSColor { get set }
    var lineColor: NSColor { get set }
    var shapeFrame: NSRect { get set }
}
