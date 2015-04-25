#MSProgressView
An iOS Progress Indicator that moves around a circle.

##Instructions
1. To use MSProgressView, simply download `MSProgressView.swift` and drag it into Xcode.
2. That's it.  If you are writing your project in Objective-C, you will have to import `XXX-Swift.h` into your `.m` file, where `XXX` is your project's name.

##Options
MSProgressView is completely customizable.  However, there are some options for quick and easy use by most develoers.

* `barColor`.  This value takes a `UIColor`.  Setting it will automatically animate the color change for you.  The default is white.
* `barWidth`.  This value takes a `CGFloat`.  Setting it will automatically animate the width change for you.  The default is 5.0.

##Methods
There are three methods you have access to.

* `startAnimating()`.  This method immediately shows the view (if it has been hidden) and begins to make the ProgressView revolve in a circle.  Use this for **indefinite** loading times.
* `stopAnimating()`.  This method does the exact opposite of `startAnimating`.  It stops the rotation and immediately hides the ProgressView from sight.
* `setProgress(progress)`.  This method begins showing the loading progress out of 100%.  If `startAnimating` was called before this method, the rotation will come to a stop and the loading prgoress will update with an animation.  Use this for **definite** loading times.