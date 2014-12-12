# 205 Beginning Core Graphics, Step 3, Lab

In this portion of the tutorial, you will draw the graph itself as well as the legend lines. When you are done, your project will look like this:

![](./3-LabImages/TrueIntro.png)

This portion of the tutorial will be done in PaintCode. 

## Adding Grid Lines

The first step is to add grid lines to your graph. You will have three, a solid one on the top and bottom and a dashed line in the middle. You start by selecting the Bezier tool in the toolbar and clicking to start position to start the line and clicking again on the right to end it. Just approximate where the line should start and end. Press escape to stop adding points. You can use the snapping guides to position the points on the same horizontal line.

![](./3-LabImages/Lab1.png)

Now that you have the line, make sure it’s selected. You can now adjust the start position and width so that it’s centered and the correct width. Set the x position to 30.5 and the width to 260. Also, set the resizing guides so that they are all squiggly.

![](./3-LabImages/Lab2.png)

You’ll notice when you do so, it will alter the code so that it uses a percentage of the frame size rather than a fixed coordinate.

Note: You’ll notice that Paintcode always sets the position of the elements to half points.  A pixel coordinate is actually the boundary between pixels, so a position of 20 is between the 19th and 20th pixel. If you tell Core Graphics to draw in between pixels, it will draw a semi transparent line on the 19th and and 20th. If however, you draw on the 19.5th pixel, it will draw an opaque line on the 19th pixel.

The next step is to give the line a color. You can just create a new color in the line stroke pane, but you’ll want to use this same color for all of your lines, so create the new color in the Colors box in the top left of the window by pressing the ‘+’ button.

![](./3-LabImages/Lab3.png)

Give the color the name ‘gridLineColor’ and set the RGB components all to .652. 

You can see that Paintcode has added a new line in the code section:

	let gridLineColor = UIColor(red: 0.652, green: 0.652, blue: 0.651, alpha: 1.000)

Keep an eye on the code window as you make changes to the interface. This is a great way to learn about how to use the Core Graphics API.

Next, drag the line from the color circle to your grid line and select ‘Stroke’.

![](./3-LabImages/Lab4.png)

Now that you have one line, just copy and paste it twice (so you have three). In the upper right pane, name the top line ‘topGridLine’, the bottom one, ‘bottomGridLine’, and the middle line ‘midGridLine’.

Using the position pane, position the top line at Y coordinate of 40.5, the middle one at 100.5, and the bottom one at 160.5.

![](./3-LabImages/Lab5.png)

You’ll see that the code references have changed to use the names you select in the pane.

Finally, you want to make the middle line dashed. Select it and in the ‘Stroke’ pane change the ‘Pattern’ dropdown from ‘Solid’ to ‘Dashed’. Set Dash to 4 and Gap to 7.

![](./3-LabImages/Lab6.png)

The final thing you need to do in Paintcode is define the rectangle where the actual graph lines will be drawn. Because the graph will be drawn dynamically based on data loaded from a plist, you can’t do much of that code in Paintcode. But, it is helpful to define a region that you want the graph drawn in.

Use the rectangle tool to create a rectangle with the following dimensions:

![](./3-LabImages/Lab7.png)

Change all the resizing options to variable (squiggly). Rename the path to lineGraphRect. Give it a stroke of any color (size and color don't matter here, but you need it to draw something or it won't generate code for it).

You’ll remove the code that strokes the rectangle when you use this in your code. For now, copy and paste your entire method into Xcode (the drawGraphCanvas declaration and all).

You need to change the call in drawRect to include the parameter name (by default Paintcode writes a method that requires the parameter name). 

drawGraphCanvas(viewFrame: rect)

Build and run now.

![](./3-LabImages/Lab8.png)

## Add the Graph

The next step is to add the graph (and remove the stroke around the rectangle). Remove these lines of code:

	UIColor.lightGrayColor().setStroke()
	lineGraphRectPath.lineWidth = 1
	lineGraphRectPath.stroke()

The current code creates a UIBezierPath variable using a supplied CGRect calculation. Change the name to lineGraphRect and remove the UIBezierPath initializer (leaving the CGRectMake intact), so you code looks like this:

	let lineGraphRect = CGRectMake(canvasFrame.minX + floor(canvasFrame.width * 0.09844) + 0.5, canvasFrame.minY + floor(canvasFrame.height * 0.24250) + 0.5, floor(canvasFrame.width * 0.91094) - floor(canvasFrame.width * 0.09844), floor(canvasFrame.height * 0.75250) - floor(canvasFrame.height * 0.24250))

Then add this new line immediately following the Rect initializer:

	let graphBezier = generateBezierPathForGraph(lineGraphRect.size)

Then add this method:

	func generateBezierPathForGraph(size : CGSize) -> UIBezierPath 
	{
	}

The included class contains an array with a series of values representing step data for 31 days. The array is called values and there are two variables (maxValues and minValues) that contain the min and max of this data set.

You are going to use this information, and the supplied rectangle, to determine where to position each point on the graph.

Start by creating a UIBezierPath object that will be returned by the method and determine the range of the supplied values. Add this code to generateBezierPathForGraph():

	let bezierPath = UIBezierPath()
	let valueDiff = maxValues - minValues

Next, you’ll loop through all the items in values and calculate an X and Y position for each one.

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

1. The Y position is calculated by subtracting the current value from the minimum and dividing that value by the difference. This results in a normalized value between 0.0 and 1.0. 
2. That value is inverted by subtracting it from 1.0 (this is because Y increases as you move downward and you want the largest values on top). 
3. Finally, that value is multiplied by the height provided by the input size variable (which, is the height of the defined rectangle in Paintcode).
4. The X position is more direct. It is calculated by dividing the input width by the number of elements in values, and then multiplied by the current index. All these need to be cast to CGFloat in order to be multiplied by size.width.

The next step is to create a CGPoint object and add that point to the Bezier path. The only tricky thing at this point is that you must us a different method on the very first point in the path.

	let point = CGPointMake(xPosition, yPosition)

	if i == 0 {
    	bezierPath.moveToPoint(point)
	} else {
    	bezierPath.addLineToPoint(point)
	}

If you are on the very first item in the array, you want to move into the first position, by calling bezierPath.moveToPoint(). Each subsequent point, you’ll call .addLineToPoint, which will create a line from the current point to the next point. 

The last step is to close the for loop and return the constructed Bezier path.

    	}   
	return bezierPath

Now that you have finished the method that creates the path, you are ready to draw it on your graph. Return to your previous place in the drawGraphCanvas method.

Add the following code to the end:

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

1. The first step is to set the current color used for stroking paths to green.
2. Next, you are saving the current state of the Core Graphics environment. 
3. CGContextTranslateCTM is a call that sets a translation on the context. A translation moves the origin point from which all drawing is done. In this case, you are moving the start point right and down (from 0.0) to the origin point of the defined rectangle. 
4. Here’s the most important part, you stroke the path. This uses the color you just set.
5. Finally, you restore the state, this puts the origin for drawing back to the default.

Build and run now. You should have a working graph. Play with the data (make up your own step counts) and see how the graph changes:

![](./3-LabImages/Final.png)
