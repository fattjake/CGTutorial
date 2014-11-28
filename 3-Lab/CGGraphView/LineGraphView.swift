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
    
    override func drawRect(rect: CGRect) {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.roundingIncrement = 1000
        let highLabel = numberFormatter.stringFromNumber(maxValues)!
        let lowLabel = numberFormatter.stringFromNumber(minValues)!
        drawBackgroundCanvas(frame: rect, highLabel: highLabel, lowLabel: lowLabel)
    }
    
    func drawBackgroundCanvas(#frame: CGRect, highLabel: String, lowLabel: String) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let backGradientStart = UIColor(red: 0.217, green: 0.250, blue: 0.180, alpha: 1.000)
        let backGradientEnd = UIColor(red: 0.477, green: 0.552, blue: 0.284, alpha: 1.000)
        let gridLineColor = UIColor(red: 0.613, green: 0.613, blue: 0.613, alpha: 1.000)
        let labelColor = UIColor(red: 0.839, green: 0.839, blue: 0.839, alpha: 1.000)
        let color = UIColor(red: 0.676, green: 0.614, blue: 0.614, alpha: 0.617)
        
        //// Gradient Declarations
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [backGradientEnd.CGColor, backGradientStart.CGColor], [0, 1])
        
        //// Rectangle Drawing
        let rectangleRect = CGRectMake(frame.minX + floor(frame.width * 0.01875 + 0.5), frame.minY + floor(frame.height * 0.04455 + 0.5), floor(frame.width * 0.98125 + 0.5) - floor(frame.width * 0.01875 + 0.5), floor(frame.height * 0.95545 + 0.5) - floor(frame.height * 0.04455 + 0.5))
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 11)
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient,
            CGPointMake(rectangleRect.midX, rectangleRect.minY),
            CGPointMake(rectangleRect.midX, rectangleRect.maxY),
            0)
        CGContextRestoreGState(context)
        
        
        //// highline Drawing
        var highlinePath = UIBezierPath()
        highlinePath.moveToPoint(CGPointMake(frame.minX + 0.05625 * frame.width, frame.minY + 41))
        highlinePath.addLineToPoint(CGPointMake(frame.minX + 0.93437 * frame.width, frame.minY + 41))
        gridLineColor.setStroke()
        highlinePath.lineWidth = 1
        highlinePath.stroke()
        
        
        //// lowline Drawing
        var lowlinePath = UIBezierPath()
        lowlinePath.moveToPoint(CGPointMake(frame.minX + 0.05625 * frame.width, frame.maxY - 35))
        lowlinePath.addLineToPoint(CGPointMake(frame.minX + 0.93437 * frame.width, frame.maxY - 35))
        gridLineColor.setStroke()
        lowlinePath.lineWidth = 1
        lowlinePath.stroke()
        
        
        //// midline Drawing
        var midlinePath = UIBezierPath()
        //This is special!
        let midLineY = (frame.maxY - 35 + frame.minY + 41) / 2
        midlinePath.moveToPoint(CGPointMake(frame.minX + 0.05625 * frame.width, midLineY))
        midlinePath.addLineToPoint(CGPointMake(frame.minX + 0.93437 * frame.width, midLineY))
        gridLineColor.setStroke()
        midlinePath.lineWidth = 1
        CGContextSaveGState(context)
        CGContextSetLineDash(context, 0, [4, 6], 2)
        midlinePath.stroke()
        CGContextRestoreGState(context)
        
        
        //// Text Drawing
        let textRect = CGRectMake(frame.minX + floor((frame.width - 49) * 0.92251 + 0.5), frame.minY + 41, 49, 15)
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Right
        
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(8), NSForegroundColorAttributeName: labelColor, NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight: CGFloat = NSString(string: highLabel).boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect);
        NSString(string: highLabel).drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)
        
        
        //// Text 2 Drawing
        let text2Rect = CGRectMake(frame.minX + floor((frame.width - 49) * 0.92251 + 0.5), frame.minY + frame.height - 50, 49, 15)
        let text2Style = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        text2Style.alignment = NSTextAlignment.Right
        
        let text2FontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(8), NSForegroundColorAttributeName: labelColor, NSParagraphStyleAttributeName: text2Style]
        
        let text2TextHeight: CGFloat = NSString(string: lowLabel).boundingRectWithSize(CGSizeMake(text2Rect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: text2FontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, text2Rect);
        NSString(string: lowLabel).drawInRect(CGRectMake(text2Rect.minX, text2Rect.minY + (text2Rect.height - text2TextHeight) / 2, text2Rect.width, text2TextHeight), withAttributes: text2FontAttributes)
        CGContextRestoreGState(context)
        
        
        //// graphRect Drawing
        let graphRect = CGRectMake(frame.minX + floor(frame.width * 0.05625 + 0.5), frame.minY + 55.5, floor(frame.width * 0.93437 + 0.5) - floor(frame.width * 0.05625 + 0.5), frame.height - 105)
        
        let graphBezier = generateBezierPathForGraph(graphRect.size)
        UIColor.greenColor().set()
        CGContextSaveGState(context)
        
        let shadow = UIColor.greenColor().colorWithAlphaComponent(0.94)
        let shadowOffset = CGSizeMake(0.0, -0.0)
        let shadowBlurRadius: CGFloat = 12
        
        CGContextTranslateCTM(context, graphRect.origin.x, graphRect.origin.y)
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, (shadow as UIColor).CGColor)
        
        graphBezier.stroke()
        
        CGContextRestoreGState(context)
    }
    
    func generateBezierPathForGraph(size : CGSize) -> UIBezierPath {
        let valueDiff = maxValues - minValues
        let gridDiff = size.height
        
        let bezierPath = UIBezierPath()
        
        for i in 0..<values.count {
            let number = values[i]
            
            let yPosition = CGFloat((1.0 - CGFloat(number - minValues) / CGFloat(valueDiff))) * size.height
            let xPosition = CGFloat(i) * (size.width / CGFloat(values.count - 1))
            
            let point = CGPointMake(xPosition, yPosition)
            
            if i == 0 {
                bezierPath.moveToPoint(point)
            } else {
                bezierPath.addLineToPoint(point)
            }
        }
        
        return bezierPath
    }
}
