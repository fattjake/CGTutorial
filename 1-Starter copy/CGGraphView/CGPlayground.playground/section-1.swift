// Playground - noun: a place where people can play

import UIKit

class LineGraphView : UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let rectangleRect = CGRectMake(10, 10, rect.size.width - 20, rect.size.height - 20)
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 11.0)
        UIColor(red: 0.217, green: 0.250, blue: 0.180, alpha: 1.0).setFill()
        rectanglePath.fill()
        
        let backGradientStart = UIColor(red: 0.477, green: 0.552, blue: 0.284, alpha: 1.000)
        let backGradientEnd = UIColor(red: 0.217, green: 0.250, blue: 0.180, alpha: 1.00)
        
        let backGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [backGradientStart.CGColor, backGradientEnd.CGColor], [0, 1])
        
        
        
        CGContextSaveGState(context)
        rectanglePath.addClip()
        
        CGContextDrawLinearGradient(context, backGradient,
            CGPointMake(rectangleRect.midX, rectangleRect.minY),
            CGPointMake(rectangleRect.midX, rectangleRect.maxY), 0)
        
        CGContextRestoreGState(context)
        
    }
}

let graphView = LineGraphView(frame: CGRectMake(0, 0, 640, 400))

