// Playground - noun: a place where people can play

import UIKit

class LineGraphView : UIView {
    
    override func drawRect(rect: CGRect) {
        drawBackgroundCanvas(rect)
    }
    
    func drawBackgroundCanvas(canvasFrame : CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let rectangleRect = CGRectMake(10, 10, canvasFrame.size.width - 20, canvasFrame.size.height - 20)
        let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 11)
        
        let backGradientStart = UIColor(red: 0.217, green: 0.250, blue: 0.180, alpha: 1.000)
        backGradientStart.setFill()
        rectanglePath.fill()
        
        let backGradientEnd = UIColor(red: 0.477, green: 0.552, blue: 0.284, alpha: 1.000)
        
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [backGradientEnd.CGColor, backGradientStart.CGColor], [0, 1])
        
        CGContextSaveGState(context)
        rectanglePath.addClip()
        
        CGContextDrawLinearGradient(context, gradient,
            CGPointMake(rectangleRect.midX, rectangleRect.minY),
            CGPointMake(rectangleRect.midX, rectangleRect.maxY),
            0)
        
        CGContextRestoreGState(context)
    }
}

let lineGraph = LineGraphView(frame: CGRectMake(0, 0, 320, 200))
