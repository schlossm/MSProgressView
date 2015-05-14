#MSProgressView
An iOS Progress Indicator that moves around a circle.

MSProgressView will work with and without AutoLayout.  To use AutoLayout, simply write
```progressView.setTranslatesAutoresizingMaskIntoConstraints(false)
```

##Instructions
1. To use MSProgressView, simply download `MSProgressView.swift` and drag it into Xcode.
2. That's it.  If you are writing your project in Objective-C, you will have to import `XXX-Swift.h` into your `.m` file, where `XXX` is your project's name.

###Swift Setup
```
-- AutoLayout Version -- (Apple Recommended Setup)

let progressView = MSProgressView()
progressView.setTranslatesAutoresizingMaskIntoConstraints(false)
progressView.startAnimating()
view.addSubview(progressView)
...

----------------------------
-- Non AutoLayout Version --

let progressView = MSProgressView(frame: CGRectMake(..., ..., ..., ...))
progressView.startAnimating()
view.addSubview(progressView)
...
```

###Objective-C Setup
```
-- AutoLayout Version -- (Apple Recommended Setup)

MSProgressView *progressView = [[MSProgressView alloc] init];
[progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
[progressView startAnimating];
[view addSubview:progressView];
...

----------------------------
-- Non AutoLayout Version -- 

MSProgressView *progressView = [[MSProgressView alloc] initWithFrame:CGRectMake(..., ..., ..., ...)];
[progressView startAnimating];
[view addSubview:progressView];
...
```

##Options
MSProgressView is completely customizable.  However, for quick setup, two(2) variables have been provided for you.

* `barColor`.  This value takes a `UIColor`.  Setting it will automatically animate the color change.  The default is white.
* `barWidth`.  This value takes a `CGFloat`.  Setting it will automatically animate the width change.  The default is 5.0.

##Methods

* `startAnimating()`  This method will immediately show the view (if it has been hidden) and begin to make the MSProgressView revolve in a circle.  Use this for **indefinite** loading times.
* `stopAnimating()`  This method will stop the rotation and immediately hide the MSProgressView from sight.
* `setProgress(progress)`  This method begins showing the loading progress out of 100%.  If `startAnimating()` was called before this method, the rotation will come to a stop and the loading prgoress will update with an animation.  Use this for **definite** loading times.
*  `showComplete()` This method will hide the progress bar and display a green circle with a white checkmark with a fancy animation.  You will not be able to update the progress after this method is called.
*  `showIncomplete()` This method will hide the progress bar and display a red circle with a white "x" with a fancy animation.  You will not be able to update the progress after this method is called.

##Values

* `currentProgress`  This value returns the current progress the MSProgressView has loaded.  **This property is** ***readonly***