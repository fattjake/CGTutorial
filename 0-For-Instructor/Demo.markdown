First, make a copy of the starter folder.

Then open the CGGraphView project file.

First we'll start with a playground. Playgrounds are an ideal place to learn about Core Graphics or any drawing API because you get immediate feedback and it makes it easy to play around and see the results from changes you make.

Open CGPlayground by selecting it in the left pane

On iOS, when you want to draw something using Core Graphics to the screen, you'll do that in a UIView subclass and override the drawRect method

You can see that this playground already provides a LineGraphView class. And an instance of that class. Click on the eye icon to bring up the live rendering of the view.

Add the following code:

# Writing your first Core Graphics Code

	override func drawRect(rect: CGRect) {
	    let context = UIGraphicsGetCurrentContext()

As I explained in the opening, the first step is to get a context. You can do that by using the UIGraphicsGetCurrentContext() call. Inside the drawRect method, there is already a graphics context that has been created and set current by the system. 
        
Next you'll define a rectangle. You use CGRectInset which takes a rectangle and provides a new rectangle that is smaller (or larger if you provide negative arguments), in this case, we want a rectangle that is 10 pixels inset from the view's rectangle. The resulting triangle is 20 pixels narrower and shorter.

    	let insetRect = CGRectInset(rect, 10, 10)

Then, you create a path. A path is basically a line. In this case you use a C call in core graphics, CGPathCreateWithRect. This takes a rectangle and creates CGPathRef object (a core graphics object) that's outlines the rectangle.

    	let rectanglePath = CGPathCreateWithRect ( insetRect, nil )

First, I'm going to show you how to use the Lowest level, core graphics calls

Next, add the path to the context. The path object doesn't have any effect on the context until you add it (stroking, filling, etc)

    	CGContextAddPath(context, rectanglePath)

then set the color on the context (remember, cgcontext is a state machine)
Show them the list of state - https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CGContext/index.html#//apple_ref/c/func/CGContextSaveGState

    	CGContextSetRGBFillColor(context, 0.2, 0.3, 0.1, 1.000)

finally call fill on the context

    	CGContextFillPath(context)
	}

# easier way - replace CGContextAddPath to CGContextFillPath

Sometimes in Core Graphics you will work with the C structs, other times Cocoa has provided an Object wrapper around the low level C objects to make it easier to work with. Where available, usually it's a good idea to work with the higher level objects. I'll explain example of that in a minute.

User higher level object - UIBezierPath - remove all 4 lines from definition of rectanglePath

This is a UIBezierPath object (a Cocoa object), not a C struct (like CGPathRef)

	let rectanglePath = UIBezierPath(roundedRect: insetRect, cornerRadius: 11)

UIColor is also an object - 

    UIColor(red: 0.2, green: 0.3, blue: 0.1, alpha: 1.00).setFill()

Calling .fill() on UIBezierPath handles the low level state on the context, and can do so more efficiently

    rectanglePath.fill()  


# Draw Gradient

Remove rectanglePath.fill()

The first step in creating a gradient is to set the start and end colors. We'll do a linear gradient, so the color will interpolate between the first and last color smoothly.

    let backGradientStart = UIColor.yellowColor()
    let backGradientEnd = UIColor.blueColor()

The second step is to define the gradient object. This is a low level C struct. To create a gradient you must provide a color space. A color space exists because color can be represented different ways, and even the same representation can look different on different devices (this is most relevant on the desktop where you have different monitors, different printers, etc - remember Core Graphics has its roots in printing to paper). On iOS you'll usually use CGColorSpaceCreateDeviceRGB which gives you back a color space based in RGB based on the device. 

Then, you provide an array of colors and an array of positions. In this case it's a simple two color gradient that smoothly interpolates. But you can provide more than two colors and a different set of positions. For example if you want to slowly move from the first to the second color, then at the last 20% of space speed up the transition, you'd use 0.2.

    let backGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), 
    	[backGradientEnd.CGColor, backGradientStart.CGColor], [0, 1])

Finally, you draw the gradient on the context. You provide the context, the gradient and the start and end positions in the view. Here you're getting the middle of the inset rect and the top and bottom points of the insetrect.

    CGContextDrawLinearGradient(context, backGradient,
            CGPoint(x: CGRectGetMidX(insetRect), y: CGRectGetMinY(insetRect)),
            CGPoint(x: CGRectGetMidX(insetRect), y: CGRectGetMaxY(insetRect)),
            0)

# Set clipping

It would be nicer if our gradient had rounded corners, I'll show you how to do that now. There are two functions that allow you to manage the state of the context (remember that big list of state I showed you earlier?) They are known as CGContextSaveGState and CGContextRestoreGState. I'll show you how to use them.

First you want to save the current state of the context.

	CGContextSaveGState(context)    

Then, you add a clipping path. This is just the path that you defined and filled earlier, the rounded inset rect. Calling addClip() on a closed path (it doesn't work on lines that don't define a bounded region) will prevent any drawing outside that defined rectangle

    rectanglePath.addClip()

![](./1-DemoImages/Demo1.png)

When you are done with the clip, when you want to remove it so you can draw outside the boundaries of that path again, you call CGContextRestoreGState which will put all the state back to what it was when you saved it earlier (effectively erasing the addClip call you just added)

	CGContextRestoreGState(context)

Mess with the gradient a little.

Next we'll move over to paintcode and see how easy paintcode makes doing the same things.


# Move to paintcode

Quick Overview of Interface

- Canvas - 2x display, 200%
- Code Window - Language/platform
- Buttons - rect, oval, etc
	Mess with a few
- Objects/Layers - Canvas - whatever else is there - mention code window
- Settings - 
- Types - Define a color - show them how to name it, how to change the number types?? - show how to drag to object - tell them about the code window not spelling out a color til it shows up


# Change canvas size

- Select Canvas
- 320 x 200

# Draw a Rectangle

- Click rect in layers 
- Size it manually - 10, 10, 300, 180
- Set rounded radius - 11

- Watch Code window

# Define Gradient

- backGradient - dark gray and light gray
- setFill by dragging and dropping

# Copy code from paintcode into drawRect

    //// General Declarations
    let context = UIGraphicsGetCurrentContext()


    //// Gradient Declarations
    let backGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [UIColor.lightGrayColor().CGColor, UIColor.darkGrayColor().CGColor], [0, 1])

    //// Rectangle Drawing
    let rectanglePath = UIBezierPath(roundedRect: CGRectMake(10, 10, 300, 180), cornerRadius: 11)
    CGContextSaveGState(context)
    rectanglePath.addClip()
    CGContextDrawLinearGradient(context, backGradient, CGPointMake(160, 10), CGPointMake(160, 190), 0)
    CGContextRestoreGState(context)


build and run - 

# Using frame

a frame is not a view - it's an abstraction used to determine how to write the code that defines positions and sizes - 

- drag from bottom right to top left to avoid top left guide
- watch how frame code changes (now has frame.minX + 10)
- fix resising 
	- select rectangle
	- all zigzag

You can see that the frame only effects the points that are inside it, so if you drag a frame around only a part of the drawn thing, then resize the frame, it doesn't do any resizing of points outside its bounds.

# Copy and paste again

- This time we need to refactor
- leave frame the same name - frame
- Rename Canvas - graph

# This Code


    override func drawRect(rect: CGRect) {
        drawGraph(frame: rect)
    }
  
    func drawGraph(#frame: CGRect) {
    //// General Declarations
    let context = UIGraphicsGetCurrentContext()


    //// Gradient Declarations
    let backGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [UIColor.lightGrayColor().CGColor, UIColor.darkGrayColor().CGColor], [0, 1])

    //// Rectangle Drawing
     let rectangleRect = CGRectMake(frame.minX + floor(frame.width * 0.03125 + 0.5), frame.minY + floor(frame.height * 0.05000 + 0.5), floor(frame.width * 0.96875 + 0.5) - floor(frame.width * 0.03125 + 0.5), floor(frame.height * 0.95000 + 0.5) - floor(frame.height * 0.05000 + 0.5))
    let rectanglePath = UIBezierPath(roundedRect: rectangleRect, cornerRadius: 11)
    CGContextSaveGState(context)
    rectanglePath.addClip()
    CGContextDrawLinearGradient(context, backGradient,
        CGPointMake(rectangleRect.midX, rectangleRect.minY),
        CGPointMake(rectangleRect.midX, rectangleRect.maxY),
        0)
    CGContextRestoreGState(context)
}


You'll notice that the background is white here, while it was black in the playground. The reason is that the playground isn't actually black, it's transparent (with nothing behind it), when we render it inside our app, the parent view has a white background, so it looks white.



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


