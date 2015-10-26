#MSProgressView
A simple, circular iOS Progress Indicator with completion & error feedback.

* **NOTE:** MSProgressView is written in Swift 2.  This requires Xcode 7+

##Setup

1. To use MSProgressView, download `MSProgressView.swift` and drag it into Xcode.
2. That's it.  If you are writing your project in Objective-C, you will have to import `XXX-Swift.h` into your `.m` file, where `XXX` is your project's name.

###Swift
```
-- AutoLayout Version -- (Apple Recommended Setup)

let progressView = MSProgressView()
progressView.translatesAutoresizingMaskIntoConstraints = false
progressView.startAnimating(false)
view.addSubview(progressView)
...

----------------------------
-- Non AutoLayout Version --

let progressView = MSProgressView(frame: CGRect(x: ..., y: ..., width: ..., height: ...))
progressView.startAnimating(false)
view.addSubview(progressView)
...
```

###Objective-C
```
-- AutoLayout Version -- (Apple Recommended Setup)

MSProgressView *progressView = [[MSProgressView alloc] init];
[progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
[progressView startAnimating:false];
[view addSubview:progressView];
...

----------------------------
-- Non AutoLayout Version -- 

MSProgressView *progressView = [[MSProgressView alloc] initWithFrame:CGRectMake(..., ..., ..., ...)];
[progressView startAnimating:false];
[view addSubview:progressView];
...
```

**Note:** MSProgressView is marked @IBDesignable.  You can initialize in Interface Builder as well as code.

##Options
MSProgressView is completely customizable.  For quick setup, two variables have been provided for you.

* `barColor` - This value takes a `UIColor`.  Setting it will automatically animate the color change.  The default is `UIColor.whiteColor()`.
* `barWidth` - This value takes a `CGFloat`.  Setting it will automatically animate the width change.  The default is `5.0`.

These values are also marked as @IBInspectable, and can be changed in Interface Builder.

##Methods

* `startAnimating(animated: Bool)`  This method will begin to make the MSProgressView revolve in a circle.  Use this for **indefinite** loading times.  
 * `animated` - `true` if your code handles display of MSProgressView. Set to `false` if you want MSProgressView to instantly appear.
* `stopAnimating(animated: Bool)`  This method will immediately stop the rotation.
 * `animated` - `true` if your code handles display of MSProgressView. Set to `false` if you want MSProgressView to instantly appear.
* `setProgress(progress: CGFloat)`  This method begins showing the loading progress out of 100%.  Use this for **definite** loading times.
*  `showComplete()` This method will hide the progress bar and display a green circle with a white checkmark with a fancy animation.  You will not be able to update the progress after this method is called.
*  `showIncomplete()` This method will hide the progress bar and display a red circle with a white "x" with a fancy animation.  You will not be able to update the progress after this method is called.
*  `reset()` This method resets MSProgressView to its initial state.

##Values

* `currentProgress` ***readonly*** This value returns the current progress the MSProgressView has loaded.