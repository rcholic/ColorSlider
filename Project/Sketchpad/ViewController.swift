//
//  ViewController.swift
//  Sketchpad
//
//  Created by Sachin Patel on 1/11/15.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-Present Sachin Patel (http://gizmosachin.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class ViewController: UIViewController, ACEDrawingViewDelegate {
    @IBOutlet var drawingView: ACEDrawingView!
    @IBOutlet var colorSlider: ColorSlider!
    @IBOutlet var selectedColorView: UIView!
    @IBOutlet var undoButton: UIBarButtonItem!
	@IBOutlet var shareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		selectedColorView.clipsToBounds = true
		selectedColorView.layer.cornerRadius = selectedColorView.frame.width / 2.0
		selectedColorView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
		selectedColorView.layer.borderWidth = 1.0
		
        drawingView.delegate = self
        drawingView.lineWidth = 3.0
        undoButton.enabled = false
		
		colorSlider.previewEnabled = true
        colorSlider.addTarget(self, action: "willChangeColor:", forControlEvents: .TouchDown)
        colorSlider.addTarget(self, action: "isChangingColor:", forControlEvents: .ValueChanged)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpOutside)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ColorSlider Events
    func willChangeColor(slider: ColorSlider) {
        drawingView.userInteractionEnabled = false
    }
    
   	func isChangingColor(slider: ColorSlider) {
        // Respond to a change in color.
    }
    
    func didChangeColor(slider: ColorSlider) {
        updateColorViews(slider.color)
        drawingView.userInteractionEnabled = true
    }
    
    func updateColorViews(color: UIColor) {
        selectedColorView.backgroundColor = color
        drawingView.lineColor = color
    }
    
    // MARK: ACEDrawingView Delegate
    func drawingView(view: ACEDrawingView, didEndDrawUsingTool tool: AnyObject) {
        undoButton.enabled = drawingView.canUndo()
    }
    
    // MARK: Actions
	@IBAction func undo(sender: UIBarButtonItem) {
        drawingView.undoLatestStep()
        undoButton.enabled = drawingView.canUndo()
    }
    
	@IBAction func share(sender: UIBarButtonItem) {
        let trimmedImage = drawingView.image.imageByTrimmingTransparentPixels()
        let controller = UIActivityViewController(activityItems: [trimmedImage], applicationActivities: nil)
		controller.completionWithItemsHandler = {
			activityType, completed, returnedItems, activityError in
			if completed {
				self.drawingView.clear()
				self.drawingView.lineColor = UIColor.blackColor()
				self.selectedColorView.backgroundColor = UIColor.blackColor()
			}
		}
		controller.popoverPresentationController?.barButtonItem = sender
		presentViewController(controller, animated: true, completion: nil)
    }
}

