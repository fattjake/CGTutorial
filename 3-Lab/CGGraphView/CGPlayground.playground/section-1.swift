// Playground - noun: a place where people can play

import UIKit

class LineGraphView : UIView {
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

let lineGraphView = LineGraphView(frame: CGRectMake(0, 0, 640, 400))