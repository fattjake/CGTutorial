# Writing your first Core Graphics Code

	override func drawRect(rect: CGRect) {
	    let context = UIGraphicsGetCurrentContext()
        
    	let rectangleRect = CGRectMake(10, 10, 
    		rect.size.width - 20, rect.size.height - 20)
    	let rectanglePath = CGPathCreateWithRect ( rect, NULL );

    	CGContextAddPath(context, rectanglePath.CGPath)
    	CGContextSetRGBFillColor(context, 0.217, 0.250, 0.180, 1.000)
    	CGContextFillPath(context)
	}

# easier way - replace CGContextAddPath to CGContextFillPath

	let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 11)
    
    UIColor(red: 0.217, green: 0.250, blue: 0.180, alpha: 1.00).setFill()
    rectanglePath.fill()  

# Draw Circle

	UIColor().grayColor().setStroke()
    let circlePath = UIBezierPath(ovalInRect: canvasFrame)
    circlePath.stroke()

# Draw Gradient

	let backGradientStart = UIColor(red: 0.477, green: 0.552, blue: 0.284, alpha: 1.000)
    let backGradientEnd = UIColor(red: 0.217, green: 0.250, blue: 0.180, alpha: 1.000)

    let backGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), 
    	[backGradientEnd.CGColor, backGradientStart.CGColor], [0, 1])

    CGContextDrawLinearGradient(context, backGradient,
            CGPointMake(rectangleRect.midX, rectangleRect.minY),
            CGPointMake(rectangleRect.midX, rectangleRect.maxY),
            0)

# Set clipping

	CGContextSaveGState(context)    
    rectanglePath.addClip()

	CGContextRestoreGState(context)

# Remove oval

	// UIColor().grayColor().setStroke()
    // let circlePath = UIBezierPath(ovalInRect: canvasFrame)
    // circlePath.stroke()

# Move to paintcode

Quick Overview of Interface

- Canvas - 2x display, 200%
- Code Window
- Buttons
	Mess with a few
- Objects/Layers
- Settings
- Types

# Change canvas size

- Select Canvas
- 320 x 200

# Draw a Rectangle

- Click rect in layers 
- Size it manually - 10, 10, 300, 180
- Set rounded radius - 11

- Watch Code window

# Define colors

- backGradientStart .217 .250 .180
- backGradientEnd .477 .552 .284

# Define Gradient

- backGradient
- setFill by dragging and dropping

# Copy code from paintcode into drawRect

        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let backGradientEnd = UIColor(red: 0.217, green: 0.250, blue: 0.180, alpha: 1.000)
        let backGradientStart = UIColor(red: 0.477, green: 0.552, blue: 0.284, alpha: 1.000)
        
        //// Gradient Declarations
        let backGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), 
        	[backGradientStart.CGColor, backGradientEnd.CGColor], [0, 1])
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRectMake(10, 10, 300, 180), cornerRadius: 11)
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, backGradient, CGPointMake(160, 10), CGPointMake(160, 190), 0)
        CGContextRestoreGState(context)

# Using frame

- drag from bottom right to top left to avoid top left guide
- watch how frame code changes (now has frame.minX + 10)
- fix resising 
	- select rectangle
	- all squiggly - watch code change

# Copy and paste again

- This time we need to refactor
- Rename Frame - canvasFrame
- Rename Canvas - graphCanvas

# This Code

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

# Show them some more interface tools (depending on time)

- Draw bezier path - new canvas
- Edit bezier path
- Make point curvy
- Go to attributes inspector - 
	- stroke
	- fill
	- miter
	- dashed
	- shadow
- Set up variable
	- X position in bezier path

# Move code to built in class


