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
        let gridLineColor = UIColor(red: 0.652, green: 0.652, blue: 0.652, alpha: 1.000)
        
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
        
        
        //// topGridLine Drawing
        var topGridLinePath = UIBezierPath()
        topGridLinePath.moveToPoint(CGPointMake(canvasFrame.minX + 0.09531 * canvasFrame.width, canvasFrame.minY + 0.20250 * canvasFrame.height))
        topGridLinePath.addCurveToPoint(CGPointMake(canvasFrame.minX + 0.90781 * canvasFrame.width, canvasFrame.minY + 0.20251 * canvasFrame.height), controlPoint1: CGPointMake(canvasFrame.minX + 0.88976 * canvasFrame.width, canvasFrame.minY + 0.20250 * canvasFrame.height), controlPoint2: CGPointMake(canvasFrame.minX + 0.90781 * canvasFrame.width, canvasFrame.minY + 0.20251 * canvasFrame.height))
        gridLineColor.setStroke()
        topGridLinePath.lineWidth = 1
        topGridLinePath.stroke()
        
        
        //// midGridLine Drawing
        var midGridLinePath = UIBezierPath()
        midGridLinePath.moveToPoint(CGPointMake(canvasFrame.minX + 0.09531 * canvasFrame.width, canvasFrame.minY + 0.50250 * canvasFrame.height))
        midGridLinePath.addCurveToPoint(CGPointMake(canvasFrame.minX + 0.90781 * canvasFrame.width, canvasFrame.minY + 0.50250 * canvasFrame.height), controlPoint1: CGPointMake(canvasFrame.minX + 0.88976 * canvasFrame.width, canvasFrame.minY + 0.50250 * canvasFrame.height), controlPoint2: CGPointMake(canvasFrame.minX + 0.90781 * canvasFrame.width, canvasFrame.minY + 0.50250 * canvasFrame.height))
        gridLineColor.setStroke()
        midGridLinePath.lineWidth = 1
        CGContextSaveGState(context)
        CGContextSetLineDash(context, 0, [4, 7], 2)
        midGridLinePath.stroke()
        CGContextRestoreGState(context)
        
        
        //// bottomGridLine Drawing
        var bottomGridLinePath = UIBezierPath()
        bottomGridLinePath.moveToPoint(CGPointMake(canvasFrame.minX + 0.09531 * canvasFrame.width, canvasFrame.minY + 0.80251 * canvasFrame.height))
        bottomGridLinePath.addCurveToPoint(CGPointMake(canvasFrame.minX + 0.90781 * canvasFrame.width, canvasFrame.minY + 0.80251 * canvasFrame.height), controlPoint1: CGPointMake(canvasFrame.minX + 0.88976 * canvasFrame.width, canvasFrame.minY + 0.80251 * canvasFrame.height), controlPoint2: CGPointMake(canvasFrame.minX + 0.90781 * canvasFrame.width, canvasFrame.minY + 0.80251 * canvasFrame.height))
        gridLineColor.setStroke()
        bottomGridLinePath.lineWidth = 1
        bottomGridLinePath.stroke()
        
        
        //// lineGraphRect Drawing
        let lineGraphRect = CGRectMake(canvasFrame.minX + floor(canvasFrame.width * 0.09844) + 0.5, canvasFrame.minY + floor(canvasFrame.height * 0.24250) + 0.5, floor(canvasFrame.width * 0.91094) - floor(canvasFrame.width * 0.09844), floor(canvasFrame.height * 0.75250) - floor(canvasFrame.height * 0.24250))
        
        let graphBezier = generateBezierPathForGraph(lineGraphRect.size)
        
        //1
        UIColor.greenColor().set()
        //2
        CGContextSaveGState(context)
        //3
        CGContextTranslateCTM(context, lineGraphRect.origin.x, lineGraphRect.origin.y)
        //4
        graphBezier.stroke()
        //5
        CGContextRestoreGState(context)
    }

    func generateBezierPathForGraph(size : CGSize) -> UIBezierPath
    {
        let bezierPath = UIBezierPath()
        let valueDiff = maxValues - minValues
        
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
            
            if i == 0 {
                bezierPath.moveToPoint(point)
            } else {
                bezierPath.addLineToPoint(point)
            }
        }
        return bezierPath
    }
}
