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
        drawBackgroundCanvas(viewFrame: rect, highBarText: highLabel, lowBarText: lowLabel);
    }
    
    func drawBackgroundCanvas(#viewFrame: CGRect, highBarText: String, lowBarText: String) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let backGradientStart = UIColor(red: 0.217, green: 0.251, blue: 0.181, alpha: 1.000)
        let backGradientEnd = UIColor(red: 0.478, green: 0.553, blue: 0.286, alpha: 1.000)
        let gridLineColor = UIColor(red: 0.652, green: 0.652, blue: 0.651, alpha: 1.000)
        
        //// Gradient Declarations
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [backGradientEnd.CGColor, backGradientStart.CGColor], [0, 1])
        
        //// Rectangle Drawing
        let rectangleRect = CGRectMake(viewFrame.minX + floor(viewFrame.width * 0.03125 + 0.5), viewFrame.minY + floor(viewFrame.height * 0.05000 + 0.5), floor(viewFrame.width * 0.96875 + 0.5) - floor(viewFrame.width * 0.03125 + 0.5), floor(viewFrame.height * 0.95000 + 0.5) - floor(viewFrame.height * 0.05000 + 0.5))
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 11)
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient,
            CGPointMake(rectangleRect.midX, rectangleRect.minY),
            CGPointMake(rectangleRect.midX, rectangleRect.maxY),
            0)
        CGContextRestoreGState(context)
        
        
        //// topGridLine Drawing
        var topGridLinePath = UIBezierPath()
        topGridLinePath.moveToPoint(CGPointMake(viewFrame.minX + 0.09531 * viewFrame.width, viewFrame.minY + 0.20917 * viewFrame.height))
        topGridLinePath.addCurveToPoint(CGPointMake(viewFrame.minX + 0.91406 * viewFrame.width, viewFrame.minY + 0.20917 * viewFrame.height), controlPoint1: CGPointMake(viewFrame.minX + 0.12344 * viewFrame.width, viewFrame.minY + 0.19417 * viewFrame.height), controlPoint2: CGPointMake(viewFrame.minX + 0.91406 * viewFrame.width, viewFrame.minY + 0.20917 * viewFrame.height))
        gridLineColor.setStroke()
        topGridLinePath.lineWidth = 1
        topGridLinePath.stroke()
        
        
        //// midGridLine Drawing
        var midGridLinePath = UIBezierPath()
        midGridLinePath.moveToPoint(CGPointMake(viewFrame.minX + 0.09219 * viewFrame.width, viewFrame.minY + 0.50917 * viewFrame.height))
        midGridLinePath.addCurveToPoint(CGPointMake(viewFrame.minX + 0.91094 * viewFrame.width, viewFrame.minY + 0.50917 * viewFrame.height), controlPoint1: CGPointMake(viewFrame.minX + 0.12031 * viewFrame.width, viewFrame.minY + 0.49417 * viewFrame.height), controlPoint2: CGPointMake(viewFrame.minX + 0.91094 * viewFrame.width, viewFrame.minY + 0.50917 * viewFrame.height))
        gridLineColor.setStroke()
        midGridLinePath.lineWidth = 1
        CGContextSaveGState(context)
        CGContextSetLineDash(context, 0, [4, 7], 2)
        midGridLinePath.stroke()
        CGContextRestoreGState(context)
        
        
        //// bottomGridLine Drawing
        var bottomGridLinePath = UIBezierPath()
        bottomGridLinePath.moveToPoint(CGPointMake(viewFrame.minX + 0.09531 * viewFrame.width, viewFrame.minY + 0.80917 * viewFrame.height))
        bottomGridLinePath.addCurveToPoint(CGPointMake(viewFrame.minX + 0.91406 * viewFrame.width, viewFrame.minY + 0.80917 * viewFrame.height), controlPoint1: CGPointMake(viewFrame.minX + 0.12344 * viewFrame.width, viewFrame.minY + 0.79417 * viewFrame.height), controlPoint2: CGPointMake(viewFrame.minX + 0.91406 * viewFrame.width, viewFrame.minY + 0.80917 * viewFrame.height))
        gridLineColor.setStroke()
        bottomGridLinePath.lineWidth = 1
        bottomGridLinePath.stroke()
        
        
        //// lineGraphRect Drawing
        let lineGraphRect = CGRectMake(viewFrame.minX + floor(viewFrame.width * 0.09531) + 0.5, viewFrame.minY + floor(viewFrame.height * 0.25250) + 0.5, floor(viewFrame.width * 0.91406) - floor(viewFrame.width * 0.09531), floor(viewFrame.height * 0.76250) - floor(viewFrame.height * 0.25250))
        let graphBezier = generateBezierPathForGraph(lineGraphRect.size)
        
        //1
        UIColor.greenColor().set()
        //2
        CGContextSaveGState(context)
        //3
        let shadow = UIColor.greenColor().colorWithAlphaComponent(0.94)
        let shadowOffset = CGSizeMake(0.0, -0.0)
        let shadowBlurRadius: CGFloat = 12
        
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, (shadow as UIColor).CGColor)
        
        CGContextTranslateCTM(context, lineGraphRect.origin.x, lineGraphRect.origin.y)
        //4
        graphBezier.stroke()
        
        graphBezier.addLineToPoint(CGPointMake(lineGraphRect.size.width, lineGraphRect.size.height))
        graphBezier.addLineToPoint(CGPointMake(0.0, lineGraphRect.size.height))
        graphBezier.closePath()
        
        graphBezier.addClip()
        let bezierBounds = CGPathGetPathBoundingBox(graphBezier.CGPath)
        //// Color Declarations
        let graphGradientStart = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.000)
        let graphGradientMid = UIColor(red: 0.7, green: 1.0, blue: 0.7, alpha: 0.8)
        let graphGradientEnd = UIColor(red: 0.647, green: 1.000, blue: 0.638, alpha: 1.000)
        
        let gradient2 = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [graphGradientEnd.CGColor, graphGradientMid.CGColor, graphGradientStart.CGColor], [0, 0.19, 1])
        
        
        CGContextDrawLinearGradient(context, gradient2,
            CGPointMake(bezierBounds.midX, bezierBounds.minY),
            CGPointMake(bezierBounds.midX, bezierBounds.maxY), 0)
        //5
        CGContextRestoreGState(context)
        
        //// lowLabel Drawing
        let lowLabelRect = CGRectMake(viewFrame.minX + floor(viewFrame.width * 0.72500 + 0.5), viewFrame.minY + floor(viewFrame.height * 0.80000 + 0.5), floor(viewFrame.width * 0.91563 + 0.5) - floor(viewFrame.width * 0.72500 + 0.5), floor(viewFrame.height * 0.90000 + 0.5) - floor(viewFrame.height * 0.80000 + 0.5))
        let lowLabelStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        lowLabelStyle.alignment = NSTextAlignment.Right
        
        let lowLabelFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(UIFont.smallSystemFontSize()), NSForegroundColorAttributeName: gridLineColor, NSParagraphStyleAttributeName: lowLabelStyle]
        
        let lowLabelTextHeight: CGFloat = NSString(string: lowBarText).boundingRectWithSize(CGSizeMake(lowLabelRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: lowLabelFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, lowLabelRect);
        NSString(string: lowBarText).drawInRect(CGRectMake(lowLabelRect.minX, lowLabelRect.minY + (lowLabelRect.height - lowLabelTextHeight) / 2, lowLabelRect.width, lowLabelTextHeight), withAttributes: lowLabelFontAttributes)
        CGContextRestoreGState(context)
        
        
        //// highLabel Drawing
        let highLabelRect = CGRectMake(viewFrame.minX + floor(viewFrame.width * 0.72500 + 0.5), viewFrame.minY + floor(viewFrame.height * 0.12000 + 0.5), floor(viewFrame.width * 0.91563 + 0.5) - floor(viewFrame.width * 0.72500 + 0.5), floor(viewFrame.height * 0.22000 + 0.5) - floor(viewFrame.height * 0.12000 + 0.5))
        let highLabelStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
        highLabelStyle.alignment = NSTextAlignment.Right
        
        let highLabelFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(UIFont.smallSystemFontSize()), NSForegroundColorAttributeName: gridLineColor, NSParagraphStyleAttributeName: highLabelStyle]
        
        let highLabelTextHeight: CGFloat = NSString(string: highBarText).boundingRectWithSize(CGSizeMake(highLabelRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: highLabelFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, highLabelRect);
        NSString(string: highBarText).drawInRect(CGRectMake(highLabelRect.minX, highLabelRect.minY + (highLabelRect.height - highLabelTextHeight) / 2, highLabelRect.width, highLabelTextHeight), withAttributes: highLabelFontAttributes)
        CGContextRestoreGState(context)
    }
    
    func generateBezierPathForGraph(size : CGSize) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        let valueDiff = maxValues - minValues
        
        let controlPointSpread : CGFloat = 5.0
        var lastPoint = CGPointZero
        for i in 0..<values.count {
            let number = values[i]
            
            //1
            let normalizedScale = CGFloat(number - minValues) / CGFloat(valueDiff);
            //2
            let invertedValue = 1.0 - normalizedScale
            //3
            let yPosition = invertedValue * size.height
            //4
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
