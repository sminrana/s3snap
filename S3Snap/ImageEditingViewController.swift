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
import AutoLayoutProxy
 
// ImageEditingViewController
// --- ImageContainer
// -------ImageEditingView

class ImageEditingViewController: NSViewController, GettingMouseEvents {
    @IBOutlet weak var colorWell: NSColorWell?
    @IBOutlet weak var lineSizeCombo: NSComboBox?
    @IBOutlet weak var scrollView: NSScrollView?
    @IBOutlet weak var imageContainer: ContainerView?
    @IBOutlet weak var imageContainerWidth: NSLayoutConstraint?
    @IBOutlet weak var imageContainerHeight: NSLayoutConstraint?
    
    public var filePath: String?
    
    private var imageEditingView: ImageEditingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.imageEditingView?.delegate = self;
        
        self.lineSizeCombo?.selectItem(at: 2)
        
        // After the screenshot draw it on the ImageEditingView
        let url: URL = URL(filePath: self.filePath!)
        do {
            let d = try Data(contentsOf: url)
            if let image = NSImage(data: d) {
                let w: Double = image.size.width
                let h: Double = image.size.height
            
                self.imageContainerWidth?.constant = w
                self.imageContainerHeight?.constant = h
                
                // Drawing the captured screenshot on a NSView
                self.imageEditingView = ImageEditingView()
                self.imageEditingView?.delegate = self;
                self.imageEditingView?.frame = NSRect(x: 0, y: 0, width: w, height: h)
                self.imageEditingView?.image = image
                
                self.imageContainer?.addSubview(self.imageEditingView!)
            }
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - GettingMouseEvents
    // All shapes must be drawn on this view
    // Each shape must a subclass of NSView which will have scaling, roating and deleting feature
    private var isArrowToolSelected: Bool = false;

    var arrowView: ArrowView?
    
    func onMouseDown(point: NSPoint) {
       
        print( " >>>>>>>>>>>>>>><<<<<view Mouse downd \(point)" )
        
        if (isArrowToolSelected) {
            self.testView?.startPoint = point
            self.testView?.endPoint = point
            self.testView?.needsDisplay = true
        }
       
    }
    
    func onMouseUp(point: NSPoint) {
        if (isArrowToolSelected) {
            self.testView?.endPoint = point
            
            //self.testView?.frame = NSRect(x: point.x, y: point.y, width: 300, height: 300)
            
            self.testView?.needsDisplay = true
            print( " view Mouse up \(point)" )
            //self.testView = nil
        }
    }
    
    func onMouseDrag(point: NSPoint) {
        if (isArrowToolSelected) {
            self.testView?.endPoint = point
            self.testView?.needsDisplay = true
        }
        
//        if (isArrowToolSelected) {
//            //print( " view Mouse drag \(point)" )
//            //arrowView?.moveLine(point: point)
//            self.testView?.path.line(to: point)
//            self.testView?.needsDisplay = true
//        }
    }
    
    var testView: TestView?
    @IBAction func onClickFilledArrowButton(sender: Any) {
        isArrowToolSelected = true;
        
//        let selectedValue =  self.lineSizeCombo!.stringValue
//        let f = CGRect(x: (self.imageEditingView?.frame.size.width)! / 2, y: (self.imageEditingView?.frame.size.height)! / 2, width: 100, height: 100)
//        let shapeAttributes = ShapeAttributes(lineWidth: selectedValue.floatValue, fillColor: self.colorWell!.color, lineColor: self.colorWell!.color, shapeFrame: f)
//        let shape = ShapeFactory.createShape(type: .arrow, shape: shapeAttributes)
        
        self.testView = TestView(frame: NSRect(origin: self.imageEditingView?.bounds.origin ?? CGPoint(x: 0, y: 0), size: self.imageEditingView?.bounds.size ?? CGSize(width: 0, height: 0)))
                //self.testView?.path.move(to: convert(event.locationInWindow, from: nil))
                //self.testView?.needsDisplay = true
        
        self.imageEditingView?.addSubview(self.testView!)
    }
    
    @IBAction func onClickRectButton(sender: Any) {
        isArrowToolSelected = false;
        let selectedValue =  self.lineSizeCombo!.stringValue
        let f = CGRect(x: (self.imageEditingView?.frame.size.width)! / 2, y: (self.imageEditingView?.frame.size.height)! / 2, width: 100, height: 100)
        let shapeAttributes = ShapeAttributes(lineWidth: selectedValue.floatValue, fillColor: self.colorWell!.color, lineColor: self.colorWell!.color, shapeFrame: f)
        let shape = ShapeFactory.createShape(type: .rectangle, shape: shapeAttributes)
       
        self.imageEditingView?.addSubview(shape)
    }
    
    @IBAction func onClickFilledRectButton(sender: Any) {
        isArrowToolSelected = false;
        
        let selectedValue =  self.lineSizeCombo!.stringValue
        let f = CGRect(x: (self.imageEditingView?.frame.size.width)! / 2, y: (self.imageEditingView?.frame.size.height)! / 2, width: 100, height: 100)
        let shapeAttributes = ShapeAttributes(lineWidth: selectedValue.floatValue, fillColor: self.colorWell!.color, lineColor: self.colorWell!.color, shapeFrame: f)
        let shape = ShapeFactory.createShape(type: .filled_rectangle, shape: shapeAttributes)
        
        self.imageEditingView?.addSubview(shape)
    }
    
    @IBAction func onClickOvalButton(sender: Any) {
        let selectedValue =  self.lineSizeCombo!.stringValue
        let f = CGRect(x: (self.imageEditingView?.frame.size.width)! / 2, y: (self.imageEditingView?.frame.size.height)! / 2, width: 100, height: 100)
        let shapeAttributes = ShapeAttributes(lineWidth: selectedValue.floatValue, fillColor: self.colorWell!.color, lineColor: self.colorWell!.color, shapeFrame: f)
        let shape = ShapeFactory.createShape(type: .oval, shape: shapeAttributes)
        
        self.imageEditingView?.addSubview(shape)
    }
    
    @IBAction func onClickFilledOvalButton(sender: Any) {
        let selectedValue =  self.lineSizeCombo!.stringValue
        let f = CGRect(x: (self.imageEditingView?.frame.size.width)! / 2, y: (self.imageEditingView?.frame.size.height)! / 2, width: 100, height: 100)
        let shapeAttributes = ShapeAttributes(lineWidth: selectedValue.floatValue, fillColor: self.colorWell!.color, lineColor: self.colorWell!.color, shapeFrame: f)
        let shape = ShapeFactory.createShape(type: .fileld_oval, shape: shapeAttributes)
        
        self.imageEditingView?.addSubview(shape)
    }

    
    @IBAction func onClickTextButton(sender: Any) {
        let selectedValue =  self.lineSizeCombo!.stringValue
        let f = CGRect(x: (self.imageEditingView?.frame.size.width)! / 2, y: (self.imageEditingView?.frame.size.height)! / 2, width: 100, height: 100)
        let shapeAttributes = ShapeAttributes(lineWidth: selectedValue.floatValue, fillColor: self.colorWell!.color, lineColor: self.colorWell!.color, shapeFrame: f)
        let shape = ShapeFactory.createShape(type: .text, shape: shapeAttributes)
        
        self.imageEditingView?.addSubview(shape)
    }
    
    @IBAction func onClickSaveButton(sender: Any) {
        makePNGFromView(view: self.imageContainer!);
    }
    
    @IBAction func onClickCancelButton(sender: Any) {
        self.closeWindow()
    }
    
    func makePNGFromView(view: NSView) {
        let rep = view.bitmapImageRepForCachingDisplay(in: view.bounds)!
        view.cacheDisplay(in: view.bounds, to: rep)
        
        if let data = rep.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) {
            let fileName = String.fileName()
            let directory = URL.init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            let tempPath = directory.appending(component: fileName)
            
            do {
                // Save data as PNG
                let _ = try data.write(to: tempPath, options: .atomic)
                
                // Read image and upload to the server
                let fileURL = tempPath.absoluteURL
                do {
                    let fileContents = try Data(contentsOf: fileURL)
                    print(fileContents)
                    
                    uploadToServer(fileName: fileName, fileContents: fileContents)
                    self.closeWindow()
                } catch let error as NSError {
                    print("Error reading file: \(error)")
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
