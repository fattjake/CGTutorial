//
//  LineGraphView.swift
//  CGGraphView
//
//  Created by Jake Gundersen on 11/27/14.
//  Copyright (c) 2014 RazeWare, LLC. All rights reserved.
//
import Foundation
import UIKit

@objc(LineGraphView) class LineGraphView : UIView {
    var values : [Int]
    var minValues : Int
    var maxValues : Int
    
    override init(frame: CGRect) {
        let file = NSBundle.mainBundle().pathForResource("Steps", ofType: "plist")
        values = NSArray(contentsOfFile: file!) as [Int]
        minValues = values.reduce(Int.max, { min($0, $1) })
        maxValues = values.reduce(Int.min, { max($0, $1) })
        
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        let file = NSBundle.mainBundle().pathForResource("Steps", ofType: "plist")
        values = NSArray(contentsOfFile: file!) as [Int]
        
        minValues = values.reduce(Int.max, { min($0, $1) })
        maxValues = values.reduce(Int.min, { max($0, $1) })
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect : CGRect ) {
        drawGraphCanvas(canvasFrame: rect)
        
    }
    
    func drawGraphCanvas(#canvasFrame: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let backGradientEnd = UIColor(red: 0.217, green: 0.250, blue: 0.180, alpha: 1.000)
        let backGradientStart = UIColor(red: 0.477, green: 0.552, blue: 0.284, alpha: 1.000)
        
        //// Gradient Declarations
        let backGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [backGradientStart.CGColor, backGradientEnd.CGColor], [0, 1])
        
        //// Rectangle Drawing
        let rectangleRect = CGRectMake(canvasFrame.minX + floor(canvasFrame.width * 0.03125 + 0.5), canvasFrame.minY + floor(canvasFrame.height * 0.05000 + 0.5), floor(canvasFrame.width * 0.96875 + 0.5) - floor(canvasFrame.width * 0.03125 + 0.5), floor(canvasFrame.height * 0.95000 + 0.5) - floor(canvasFrame.height * 0.05000 + 0.5))
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 11)
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, backGradient,
            CGPointMake(rectangleRect.midX, rectangleRect.minY),
            CGPointMake(rectangleRect.midX, rectangleRect.maxY),
            0)
        CGContextRestoreGState(context)
    }
}
