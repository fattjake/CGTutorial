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
    let controlDistance : CGFloat = 8
    
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
        
        //// footIcon Drawing
        var footIconPath = UIBezierPath()
        footIconPath.moveToPoint(CGPointMake(frame.minX + 54.61, frame.minY + 26.03))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 48.92, frame.minY + 25.3), controlPoint1: CGPointMake(frame.minX + 53.4, frame.minY + 25.79), controlPoint2: CGPointMake(frame.minX + 51.36, frame.minY + 25.79))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 49.25, frame.minY + 27.45))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 48.74, frame.minY + 28.22), controlPoint1: CGPointMake(frame.minX + 49.31, frame.minY + 27.82), controlPoint2: CGPointMake(frame.minX + 49.08, frame.minY + 28.16))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 48.63, frame.minY + 28.23), controlPoint1: CGPointMake(frame.minX + 48.7, frame.minY + 28.23), controlPoint2: CGPointMake(frame.minX + 48.67, frame.minY + 28.23))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 48.01, frame.minY + 27.67), controlPoint1: CGPointMake(frame.minX + 48.33, frame.minY + 28.23), controlPoint2: CGPointMake(frame.minX + 48.06, frame.minY + 28))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 47.66, frame.minY + 25.44))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 47.19, frame.minY + 24.89), controlPoint1: CGPointMake(frame.minX + 47.62, frame.minY + 25.2), controlPoint2: CGPointMake(frame.minX + 47.41, frame.minY + 24.95))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 46.81, frame.minY + 24.77), controlPoint1: CGPointMake(frame.minX + 47.06, frame.minY + 24.85), controlPoint2: CGPointMake(frame.minX + 46.94, frame.minY + 24.81))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 46.48, frame.minY + 25.09), controlPoint1: CGPointMake(frame.minX + 46.59, frame.minY + 24.7), controlPoint2: CGPointMake(frame.minX + 46.44, frame.minY + 24.84))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 46.65, frame.minY + 26.21))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 46.13, frame.minY + 26.99), controlPoint1: CGPointMake(frame.minX + 46.71, frame.minY + 26.58), controlPoint2: CGPointMake(frame.minX + 46.48, frame.minY + 26.92))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 46.03, frame.minY + 26.99), controlPoint1: CGPointMake(frame.minX + 46.1, frame.minY + 26.99), controlPoint2: CGPointMake(frame.minX + 46.06, frame.minY + 26.99))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 45.41, frame.minY + 26.43), controlPoint1: CGPointMake(frame.minX + 45.73, frame.minY + 26.99), controlPoint2: CGPointMake(frame.minX + 45.46, frame.minY + 26.76))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 45.12, frame.minY + 24.58))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 44.66, frame.minY + 23.97), controlPoint1: CGPointMake(frame.minX + 45.08, frame.minY + 24.33), controlPoint2: CGPointMake(frame.minX + 44.88, frame.minY + 24.06))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 44.21, frame.minY + 23.76), controlPoint1: CGPointMake(frame.minX + 44.51, frame.minY + 23.9), controlPoint2: CGPointMake(frame.minX + 44.36, frame.minY + 23.83))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 43.9, frame.minY + 24.01), controlPoint1: CGPointMake(frame.minX + 44, frame.minY + 23.66), controlPoint2: CGPointMake(frame.minX + 43.86, frame.minY + 23.77))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 44.05, frame.minY + 24.97))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 43.53, frame.minY + 25.75), controlPoint1: CGPointMake(frame.minX + 44.11, frame.minY + 25.34), controlPoint2: CGPointMake(frame.minX + 43.88, frame.minY + 25.69))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 43.43, frame.minY + 25.76), controlPoint1: CGPointMake(frame.minX + 43.5, frame.minY + 25.75), controlPoint2: CGPointMake(frame.minX + 43.46, frame.minY + 25.76))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 42.81, frame.minY + 25.2), controlPoint1: CGPointMake(frame.minX + 43.13, frame.minY + 25.76), controlPoint2: CGPointMake(frame.minX + 42.86, frame.minY + 25.52))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 42.5, frame.minY + 23.22))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 42.07, frame.minY + 22.55), controlPoint1: CGPointMake(frame.minX + 42.46, frame.minY + 22.98), controlPoint2: CGPointMake(frame.minX + 42.27, frame.minY + 22.68))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 41.51, frame.minY + 22.16), controlPoint1: CGPointMake(frame.minX + 41.89, frame.minY + 22.43), controlPoint2: CGPointMake(frame.minX + 41.7, frame.minY + 22.3))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 41.23, frame.minY + 22.35), controlPoint1: CGPointMake(frame.minX + 41.32, frame.minY + 22.03), controlPoint2: CGPointMake(frame.minX + 41.2, frame.minY + 22.11))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 41.45, frame.minY + 23.73))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 40.93, frame.minY + 24.51), controlPoint1: CGPointMake(frame.minX + 41.51, frame.minY + 24.1), controlPoint2: CGPointMake(frame.minX + 41.28, frame.minY + 24.45))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 40.83, frame.minY + 24.52), controlPoint1: CGPointMake(frame.minX + 40.9, frame.minY + 24.51), controlPoint2: CGPointMake(frame.minX + 40.86, frame.minY + 24.52))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 40.21, frame.minY + 23.96), controlPoint1: CGPointMake(frame.minX + 40.53, frame.minY + 24.52), controlPoint2: CGPointMake(frame.minX + 40.26, frame.minY + 24.28))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 39.67, frame.minY + 20.53))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 39.34, frame.minY + 20.09), controlPoint1: CGPointMake(frame.minX + 39.55, frame.minY + 20.37), controlPoint2: CGPointMake(frame.minX + 39.43, frame.minY + 20.22))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 35.75, frame.minY + 16.51), controlPoint1: CGPointMake(frame.minX + 38.57, frame.minY + 19), controlPoint2: CGPointMake(frame.minX + 37.02, frame.minY + 16.99))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 33.11, frame.minY + 17.99), controlPoint1: CGPointMake(frame.minX + 34.41, frame.minY + 16), controlPoint2: CGPointMake(frame.minX + 33.34, frame.minY + 17.03))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 33.34, frame.minY + 19.74), controlPoint1: CGPointMake(frame.minX + 32.99, frame.minY + 18.47), controlPoint2: CGPointMake(frame.minX + 33.19, frame.minY + 19.27))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 33.78, frame.minY + 20.61), controlPoint1: CGPointMake(frame.minX + 33.43, frame.minY + 20.03), controlPoint2: CGPointMake(frame.minX + 33.57, frame.minY + 20.35))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 33.85, frame.minY + 21.7), controlPoint1: CGPointMake(frame.minX + 34.09, frame.minY + 20.99), controlPoint2: CGPointMake(frame.minX + 34.2, frame.minY + 21.38))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 29.68, frame.minY + 24.42), controlPoint1: CGPointMake(frame.minX + 33.02, frame.minY + 22.45), controlPoint2: CGPointMake(frame.minX + 31.46, frame.minY + 23.72))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 25.58, frame.minY + 23.9), controlPoint1: CGPointMake(frame.minX + 26.19, frame.minY + 25.81), controlPoint2: CGPointMake(frame.minX + 25.58, frame.minY + 23.9))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 23.57, frame.minY + 20.26), controlPoint1: CGPointMake(frame.minX + 25.58, frame.minY + 23.9), controlPoint2: CGPointMake(frame.minX + 24.81, frame.minY + 21.22))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 21.97, frame.minY + 19.98), controlPoint1: CGPointMake(frame.minX + 23.19, frame.minY + 19.97), controlPoint2: CGPointMake(frame.minX + 22.42, frame.minY + 19.86))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 21.52, frame.minY + 20.16), controlPoint1: CGPointMake(frame.minX + 21.81, frame.minY + 20.02), controlPoint2: CGPointMake(frame.minX + 21.66, frame.minY + 20.08))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 28.3, frame.minY + 28.77), controlPoint1: CGPointMake(frame.minX + 21.8, frame.minY + 21.88), controlPoint2: CGPointMake(frame.minX + 23.01, frame.minY + 26.04))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 51.42, frame.minY + 33.13), controlPoint1: CGPointMake(frame.minX + 35.17, frame.minY + 32.32), controlPoint2: CGPointMake(frame.minX + 48.85, frame.minY + 33.02))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 51.42, frame.minY + 33.22), controlPoint1: CGPointMake(frame.minX + 51.65, frame.minY + 33.14), controlPoint2: CGPointMake(frame.minX + 51.65, frame.minY + 33.18))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 36.85, frame.minY + 33.7), controlPoint1: CGPointMake(frame.minX + 49.75, frame.minY + 33.52), controlPoint2: CGPointMake(frame.minX + 43.28, frame.minY + 34.55))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 19.75, frame.minY + 23.38), controlPoint1: CGPointMake(frame.minX + 28.94, frame.minY + 32.66), controlPoint2: CGPointMake(frame.minX + 21.65, frame.minY + 30.23))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 19.64, frame.minY + 23.79), controlPoint1: CGPointMake(frame.minX + 19.71, frame.minY + 23.53), controlPoint2: CGPointMake(frame.minX + 19.67, frame.minY + 23.67))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 18.98, frame.minY + 27.76), controlPoint1: CGPointMake(frame.minX + 19.33, frame.minY + 24.82), controlPoint2: CGPointMake(frame.minX + 19.04, frame.minY + 25.51))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 18.62, frame.minY + 29.47), controlPoint1: CGPointMake(frame.minX + 18.97, frame.minY + 28.26), controlPoint2: CGPointMake(frame.minX + 18.78, frame.minY + 29.01))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 18.19, frame.minY + 31.85), controlPoint1: CGPointMake(frame.minX + 18.42, frame.minY + 30.02), controlPoint2: CGPointMake(frame.minX + 18.22, frame.minY + 30.84))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 18.17, frame.minY + 34.32), controlPoint1: CGPointMake(frame.minX + 18.16, frame.minY + 32.86), controlPoint2: CGPointMake(frame.minX + 18.16, frame.minY + 33.72))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 18.87, frame.minY + 35.74), controlPoint1: CGPointMake(frame.minX + 18.18, frame.minY + 34.81), controlPoint2: CGPointMake(frame.minX + 18.47, frame.minY + 35.49))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 19.93, frame.minY + 36.22), controlPoint1: CGPointMake(frame.minX + 19.15, frame.minY + 35.92), controlPoint2: CGPointMake(frame.minX + 19.51, frame.minY + 36.1))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 21.51, frame.minY + 36.71), controlPoint1: CGPointMake(frame.minX + 20.38, frame.minY + 36.34), controlPoint2: CGPointMake(frame.minX + 21.07, frame.minY + 36.56))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 22.18, frame.minY + 36.86), controlPoint1: CGPointMake(frame.minX + 21.71, frame.minY + 36.78), controlPoint2: CGPointMake(frame.minX + 21.93, frame.minY + 36.83))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 23.38, frame.minY + 36.86), controlPoint1: CGPointMake(frame.minX + 22.64, frame.minY + 36.91), controlPoint2: CGPointMake(frame.minX + 23.18, frame.minY + 36.85))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 23.74, frame.minY + 37.11), controlPoint1: CGPointMake(frame.minX + 23.58, frame.minY + 36.87), controlPoint2: CGPointMake(frame.minX + 23.74, frame.minY + 36.98))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 24.29, frame.minY + 37.34), controlPoint1: CGPointMake(frame.minX + 23.74, frame.minY + 37.24), controlPoint2: CGPointMake(frame.minX + 23.99, frame.minY + 37.34))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 25.02, frame.minY + 37.04), controlPoint1: CGPointMake(frame.minX + 24.58, frame.minY + 37.34), controlPoint2: CGPointMake(frame.minX + 24.91, frame.minY + 37.21))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 25.49, frame.minY + 36.74), controlPoint1: CGPointMake(frame.minX + 25.13, frame.minY + 36.88), controlPoint2: CGPointMake(frame.minX + 25.34, frame.minY + 36.74))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 25.77, frame.minY + 37.04), controlPoint1: CGPointMake(frame.minX + 25.65, frame.minY + 36.74), controlPoint2: CGPointMake(frame.minX + 25.77, frame.minY + 36.88))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 26.28, frame.minY + 37.34), controlPoint1: CGPointMake(frame.minX + 25.77, frame.minY + 37.21), controlPoint2: CGPointMake(frame.minX + 26, frame.minY + 37.34))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 26.96, frame.minY + 37.02), controlPoint1: CGPointMake(frame.minX + 26.56, frame.minY + 37.34), controlPoint2: CGPointMake(frame.minX + 26.86, frame.minY + 37.2))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 27.4, frame.minY + 36.71), controlPoint1: CGPointMake(frame.minX + 27.06, frame.minY + 36.85), controlPoint2: CGPointMake(frame.minX + 27.25, frame.minY + 36.71))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 27.85, frame.minY + 37.02), controlPoint1: CGPointMake(frame.minX + 27.54, frame.minY + 36.71), controlPoint2: CGPointMake(frame.minX + 27.74, frame.minY + 36.85))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 28.5, frame.minY + 37.34), controlPoint1: CGPointMake(frame.minX + 27.96, frame.minY + 37.2), controlPoint2: CGPointMake(frame.minX + 28.25, frame.minY + 37.34))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 29.13, frame.minY + 37.04), controlPoint1: CGPointMake(frame.minX + 28.75, frame.minY + 37.34), controlPoint2: CGPointMake(frame.minX + 29.03, frame.minY + 37.21))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 29.63, frame.minY + 37.04), controlPoint1: CGPointMake(frame.minX + 29.22, frame.minY + 36.88), controlPoint2: CGPointMake(frame.minX + 29.45, frame.minY + 36.88))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 30.58, frame.minY + 37.34), controlPoint1: CGPointMake(frame.minX + 29.82, frame.minY + 37.21), controlPoint2: CGPointMake(frame.minX + 30.24, frame.minY + 37.34))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 31.27, frame.minY + 37.1), controlPoint1: CGPointMake(frame.minX + 30.91, frame.minY + 37.34), controlPoint2: CGPointMake(frame.minX + 31.23, frame.minY + 37.23))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 31.68, frame.minY + 36.86), controlPoint1: CGPointMake(frame.minX + 31.32, frame.minY + 36.97), controlPoint2: CGPointMake(frame.minX + 31.5, frame.minY + 36.86))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 32.17, frame.minY + 37.1), controlPoint1: CGPointMake(frame.minX + 31.85, frame.minY + 36.86), controlPoint2: CGPointMake(frame.minX + 32.07, frame.minY + 36.96))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 32.92, frame.minY + 37.21), controlPoint1: CGPointMake(frame.minX + 32.26, frame.minY + 37.23), controlPoint2: CGPointMake(frame.minX + 32.6, frame.minY + 37.28))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 33.65, frame.minY + 36.74), controlPoint1: CGPointMake(frame.minX + 33.23, frame.minY + 37.14), controlPoint2: CGPointMake(frame.minX + 33.56, frame.minY + 36.93))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 34.05, frame.minY + 36.67), controlPoint1: CGPointMake(frame.minX + 33.74, frame.minY + 36.56), controlPoint2: CGPointMake(frame.minX + 33.92, frame.minY + 36.53))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 34.87, frame.minY + 37.02), controlPoint1: CGPointMake(frame.minX + 34.19, frame.minY + 36.81), controlPoint2: CGPointMake(frame.minX + 34.55, frame.minY + 36.97))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 35.73, frame.minY + 36.89), controlPoint1: CGPointMake(frame.minX + 35.19, frame.minY + 37.08), controlPoint2: CGPointMake(frame.minX + 35.58, frame.minY + 37.02))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 36.29, frame.minY + 36.72), controlPoint1: CGPointMake(frame.minX + 35.88, frame.minY + 36.77), controlPoint2: CGPointMake(frame.minX + 36.13, frame.minY + 36.69))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 36.57, frame.minY + 37.06), controlPoint1: CGPointMake(frame.minX + 36.44, frame.minY + 36.76), controlPoint2: CGPointMake(frame.minX + 36.57, frame.minY + 36.91))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 37.16, frame.minY + 37.34), controlPoint1: CGPointMake(frame.minX + 36.57, frame.minY + 37.22), controlPoint2: CGPointMake(frame.minX + 36.83, frame.minY + 37.34))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 37.97, frame.minY + 37.15), controlPoint1: CGPointMake(frame.minX + 37.49, frame.minY + 37.34), controlPoint2: CGPointMake(frame.minX + 37.85, frame.minY + 37.26))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 38.47, frame.minY + 37.02), controlPoint1: CGPointMake(frame.minX + 38.08, frame.minY + 37.05), controlPoint2: CGPointMake(frame.minX + 38.31, frame.minY + 36.99))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 38.77, frame.minY + 37.27), controlPoint1: CGPointMake(frame.minX + 38.64, frame.minY + 37.05), controlPoint2: CGPointMake(frame.minX + 38.77, frame.minY + 37.16))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 39.14, frame.minY + 37.45), controlPoint1: CGPointMake(frame.minX + 38.77, frame.minY + 37.37), controlPoint2: CGPointMake(frame.minX + 38.93, frame.minY + 37.45))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 39.8, frame.minY + 37.3), controlPoint1: CGPointMake(frame.minX + 39.34, frame.minY + 37.45), controlPoint2: CGPointMake(frame.minX + 39.64, frame.minY + 37.39))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 40.31, frame.minY + 37.19), controlPoint1: CGPointMake(frame.minX + 39.96, frame.minY + 37.22), controlPoint2: CGPointMake(frame.minX + 40.19, frame.minY + 37.17))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 40.52, frame.minY + 37.44), controlPoint1: CGPointMake(frame.minX + 40.42, frame.minY + 37.21), controlPoint2: CGPointMake(frame.minX + 40.52, frame.minY + 37.32))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 41.35, frame.minY + 37.64), controlPoint1: CGPointMake(frame.minX + 40.52, frame.minY + 37.55), controlPoint2: CGPointMake(frame.minX + 40.89, frame.minY + 37.64))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 41.42, frame.minY + 37.64))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 42.26, frame.minY + 37.34), controlPoint1: CGPointMake(frame.minX + 41.89, frame.minY + 37.64), controlPoint2: CGPointMake(frame.minX + 42.26, frame.minY + 37.51))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 42.56, frame.minY + 37.04), controlPoint1: CGPointMake(frame.minX + 42.26, frame.minY + 37.18), controlPoint2: CGPointMake(frame.minX + 42.4, frame.minY + 37.04))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 42.86, frame.minY + 37.34), controlPoint1: CGPointMake(frame.minX + 42.72, frame.minY + 37.04), controlPoint2: CGPointMake(frame.minX + 42.86, frame.minY + 37.18))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 43.59, frame.minY + 37.64), controlPoint1: CGPointMake(frame.minX + 42.86, frame.minY + 37.51), controlPoint2: CGPointMake(frame.minX + 43.18, frame.minY + 37.64))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 44.64, frame.minY + 37.44), controlPoint1: CGPointMake(frame.minX + 44, frame.minY + 37.64), controlPoint2: CGPointMake(frame.minX + 44.46, frame.minY + 37.55))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 45.22, frame.minY + 37.44), controlPoint1: CGPointMake(frame.minX + 44.81, frame.minY + 37.32), controlPoint2: CGPointMake(frame.minX + 45.07, frame.minY + 37.32))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 46.3, frame.minY + 37.64), controlPoint1: CGPointMake(frame.minX + 45.36, frame.minY + 37.55), controlPoint2: CGPointMake(frame.minX + 45.84, frame.minY + 37.64))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 47.29, frame.minY + 37.38), controlPoint1: CGPointMake(frame.minX + 46.75, frame.minY + 37.64), controlPoint2: CGPointMake(frame.minX + 47.2, frame.minY + 37.52))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 47.77, frame.minY + 37.02), controlPoint1: CGPointMake(frame.minX + 47.39, frame.minY + 37.24), controlPoint2: CGPointMake(frame.minX + 47.6, frame.minY + 37.08))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 48.2, frame.minY + 37.19), controlPoint1: CGPointMake(frame.minX + 47.93, frame.minY + 36.97), controlPoint2: CGPointMake(frame.minX + 48.13, frame.minY + 37.05))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 49.17, frame.minY + 37.28), controlPoint1: CGPointMake(frame.minX + 48.28, frame.minY + 37.34), controlPoint2: CGPointMake(frame.minX + 48.71, frame.minY + 37.38))
        footIconPath.addLineToPoint(CGPointMake(frame.minX + 49.3, frame.minY + 37.25))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 50.23, frame.minY + 36.72), controlPoint1: CGPointMake(frame.minX + 49.76, frame.minY + 37.16), controlPoint2: CGPointMake(frame.minX + 50.17, frame.minY + 36.92))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 50.53, frame.minY + 36.33), controlPoint1: CGPointMake(frame.minX + 50.29, frame.minY + 36.53), controlPoint2: CGPointMake(frame.minX + 50.42, frame.minY + 36.35))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 50.93, frame.minY + 36.58), controlPoint1: CGPointMake(frame.minX + 50.63, frame.minY + 36.31), controlPoint2: CGPointMake(frame.minX + 50.81, frame.minY + 36.42))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 51.7, frame.minY + 36.69), controlPoint1: CGPointMake(frame.minX + 51.04, frame.minY + 36.73), controlPoint2: CGPointMake(frame.minX + 51.39, frame.minY + 36.78))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 52.34, frame.minY + 36), controlPoint1: CGPointMake(frame.minX + 52.01, frame.minY + 36.59), controlPoint2: CGPointMake(frame.minX + 52.3, frame.minY + 36.28))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 52.8, frame.minY + 35.34), controlPoint1: CGPointMake(frame.minX + 52.39, frame.minY + 35.71), controlPoint2: CGPointMake(frame.minX + 52.59, frame.minY + 35.42))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 53.16, frame.minY + 35.59), controlPoint1: CGPointMake(frame.minX + 53, frame.minY + 35.27), controlPoint2: CGPointMake(frame.minX + 53.16, frame.minY + 35.38))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 53.95, frame.minY + 35.64), controlPoint1: CGPointMake(frame.minX + 53.16, frame.minY + 35.79), controlPoint2: CGPointMake(frame.minX + 53.52, frame.minY + 35.82))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 54.74, frame.minY + 34.95), controlPoint1: CGPointMake(frame.minX + 54.39, frame.minY + 35.47), controlPoint2: CGPointMake(frame.minX + 54.74, frame.minY + 35.16))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 55, frame.minY + 34.47), controlPoint1: CGPointMake(frame.minX + 54.74, frame.minY + 34.75), controlPoint2: CGPointMake(frame.minX + 54.85, frame.minY + 34.53))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 55.42, frame.minY + 34.52), controlPoint1: CGPointMake(frame.minX + 55.14, frame.minY + 34.4), controlPoint2: CGPointMake(frame.minX + 55.33, frame.minY + 34.43))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 55.99, frame.minY + 34.37), controlPoint1: CGPointMake(frame.minX + 55.5, frame.minY + 34.61), controlPoint2: CGPointMake(frame.minX + 55.76, frame.minY + 34.55))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 56.48, frame.minY + 33.76), controlPoint1: CGPointMake(frame.minX + 56.23, frame.minY + 34.2), controlPoint2: CGPointMake(frame.minX + 56.45, frame.minY + 33.92))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 57.22, frame.minY + 32.92), controlPoint1: CGPointMake(frame.minX + 56.52, frame.minY + 33.59), controlPoint2: CGPointMake(frame.minX + 56.88, frame.minY + 33.25))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 58.4, frame.minY + 28.77), controlPoint1: CGPointMake(frame.minX + 57.92, frame.minY + 32.22), controlPoint2: CGPointMake(frame.minX + 58.86, frame.minY + 30.85))
        footIconPath.addCurveToPoint(CGPointMake(frame.minX + 54.61, frame.minY + 26.03), controlPoint1: CGPointMake(frame.minX + 57.71, frame.minY + 25.62), controlPoint2: CGPointMake(frame.minX + 57.18, frame.minY + 26.53))
        footIconPath.closePath()
        footIconPath.miterLimit = 4;
        gridLineColor.setFill()
        footIconPath.fill()
        //// graphRect Drawing
        let graphRect = CGRectMake(frame.minX + floor(frame.width * 0.05625 + 0.5), frame.minY + 55.5, floor(frame.width * 0.93437 + 0.5) - floor(frame.width * 0.05625 + 0.5), frame.height - 105)
        
        let graphBezier = generateBezierPathForGraph(controlDistance, size: graphRect.size)
        UIColor.greenColor().set()
        CGContextSaveGState(context)
        
        let shadow = UIColor.greenColor().colorWithAlphaComponent(0.94)
        let shadowOffset = CGSizeMake(0.0, -0.0)
        let shadowBlurRadius: CGFloat = 12
        
        CGContextTranslateCTM(context, graphRect.origin.x, graphRect.origin.y)
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, (shadow as UIColor).CGColor)
        
        graphBezier.stroke()
        
        graphBezier.addLineToPoint(CGPointMake(graphRect.size.width, graphRect.size.height))
        graphBezier.addLineToPoint(CGPointMake(0.0, graphRect.size.height))
        graphBezier.closePath()
        
        graphBezier.addClip()
        let bezierBounds = CGPathGetPathBoundingBox(graphBezier.CGPath)
        //// Color Declarations
        let graphGradientStart = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.000)
        let graphGradientMid = UIColor(red: 0.7, green: 1.0, blue: 0.7, alpha: 0.8)
        let graphGradientEnd = UIColor(red: 0.647, green: 1.000, blue: 0.638, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient2 = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [graphGradientEnd.CGColor, graphGradientMid.CGColor, graphGradientStart.CGColor], [0, 0.19, 1])
        
        
        CGContextDrawLinearGradient(context, gradient2,
            CGPointMake(bezierBounds.midX, bezierBounds.minY),
            CGPointMake(bezierBounds.midX, bezierBounds.maxY), 0)
        
        CGContextRestoreGState(context)
    }
    
    func generateBezierPathForGraph(controlPointSpread : CGFloat, size : CGSize) -> UIBezierPath {
        let valueDiff = maxValues - minValues
        let gridDiff = size.height
        
        let bezierPath = UIBezierPath()
        
        var lastPoint = CGPointZero
        for i in 0..<values.count {
            let number = values[i]
            
            let yPosition = CGFloat((1.0 - CGFloat(number - minValues) / CGFloat(valueDiff))) * size.height
            let xPosition = CGFloat(i) * (size.width / CGFloat(values.count - 1))
            
            let point = CGPointMake(xPosition, yPosition)
            let controlPointOne = CGPointMake(lastPoint.x + controlPointSpread, lastPoint.y)
            let controlPointTwo = CGPointMake(xPosition - controlPointSpread, yPosition)
            
            if i == 0 {
                bezierPath.moveToPoint(point)
            } else {
                bezierPath.addCurveToPoint(point, controlPoint1:controlPointOne, controlPoint2: controlPointTwo)
            }
            lastPoint = point
        }
        
        return bezierPath
    }
}
