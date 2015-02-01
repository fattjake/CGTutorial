# 205 Beginning Core Graphics, Step 4, Challenge

## Challenge 1 - Make Graph Curvy

The first challenge is to change your line graph from straight lines to curvy ones. You can use paintcode to help you learn how to create curvy lines by creating a sample path on a new Canvas:

![](./4-ChallengeImages/Challenge1.png)

Right click on the Bezier path and choose ‘Edit Path’. Once you have the path in editing mode, right click on one of the control points and choose, ‘Make Point Round’. This will add control points to that point. You can see that it will alter the underlying code to use addCurveToPoint:controlPoint1:controlPoint2: instead of the simpler api call addCurveToPoint:

Note: You can move the control points independantly by holding down the Option key.

Now, you need to alter your existing generateBezierPathForGraph() call to add control points for every point you add to the curve. You can do this however you want to make your graph look how you want it, but one simple way is simply add control points at the same height but slightly to the left or right of each line segment end point. Keep one thing in mind, control point one is associated with the previous point (the segment start point) in the curve and control point two is associated with the endpoint, like this:

![](./4-ChallengeImages/Challenge2.png)

So, you’ll need to keep track of the previous point in your code so you can put control point one at the right height.

When you are done, your graph should like about like this:

![](./4-ChallengeImages/Challenge3.png)

## Challenge 2 – Make graph glow

The next thing your graph needs is a little more polish to make it look nice. Why don’t you make the line glow? What about a nice gradient underneath it to make it a bit more stylish.

The first step is glow. One hint on adding glow, glow is created the same way that a shadow is created, just with some slightly different properties.

Keep in mind that adding a shadow changes the Core Graphics state, so you’ll want to put the code that sets the shadow state inside CGContextSaveGState()/CGContextRestoreGState() code. Adding the glow will make your graph look like this (depending on the settings you choose – feel free to play with these, and use Paintcode if it helps you visualize different choices quickly):

![](./4-ChallengeImages/Challenge4.png)

## Challenge 3 – Add a gradient

Finally, the gradient. In order to add a gradient to the underside of your path, you’ll want to use the path to set the clipping and draw a gradient inside it. You have to close off the path in order to use it as a clipping path. You’ll want to add some additional points to the curve in order to define the area you want to draw a gradient into. Your Bezier path should be appended to this shape:

![](./4-ChallengeImages/Challenge5.png)

(The red dashed lines indicated the final path, you won’t actually stroke the path with a red, dashed line).

You will want a gradient that starts out light green, this color: 

	UIColor(red: 0.647, green: 1.000, blue: 0.638, alpha: 1.000)

And fades to a transparent white, this color:

	UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.000)

You can use the same series of calls once you’ve set the clip on your new path as you used to draw the gradient in the background rounded rectangle.

When you are done, you should have this:

![](./4-ChallengeImages/Challenge6.png)

## Challenge 4 - Adding Text Labels

The last task is to add some text labels that mark the top and bottom lines on the graph.
In order to do this, I suggest going back to paintcode file you created earlier and adding labels to it, using a variable to set the text of the label, and using dynamic positioning to place them below the gray top and bottom lines in the graph. Then copy and paste the changes you see in the code editor into your final file.

Doing this will change the parameters included in drawBackgroundCanvas method (including the two new variables for the text). Pass in the minValues and maxValues variables to set the text of the labels (and for bonus points, use NSFormatter or some other code to round them up and down to the nearest thousand steps).

When you’re done, you should have this:

![](./4-ChallengeImages/Challenge7.png)

