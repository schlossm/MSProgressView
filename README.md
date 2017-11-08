# MSProgressView
### A simple, circular Progress Indicator with completion success/error feedback

**NOTE:** MSProgressView is written in Swift 4.  This requires Xcode 9+

## Setup

1. To use MSProgressView, download `MSProgressView.swift` and drag it into Xcode
2. That's it.  If you are writing your project in Objective-C, you will have to import `XXX-Swift.h` into your `.m` file, where `XXX` is your project's name

You can also find `MSProgressView` on CocoaPods under `MSCircularProgressView`

### Swift
```
-- AutoLayout --

let progressView = MSProgressView()
progressView.start()
view.addSubview(progressView)
NSLayoutConstraint.activate([...])
...

--------------------
-- Non-AutoLayout --

let progressView = MSProgressView(frame: CGRect(x: ..., y: ..., width: ..., height: ...))
progressView.start()
view.addSubview(progressView)
...
```

###Objective-C
```
-- AutoLayout --

MSProgressView *progressView = [[MSProgressView alloc] init];
[progressView start];
[view addSubview: progressView];
[NSLayoutConstraint activate: @[...]];
...

--------------------
-- Non AutoLayout -- 

MSProgressView *progressView = [[MSProgressView alloc] initWithFrame: CGRectMake(..., ..., ..., ...)];
[progressView start];
[self.view addSubview: progressView];
...
```

**Note:** MSProgressView is marked @IBDesignable.  You can initialize in Interface Builder as well and customize any of the below Options

## Options
MSProgressView is completely customizable.  For quick setup, two variables have been provided for you

#### `barColor`
The color of the progress bar.  Use `setBar(color:, animated:)` if you want to animate this change

The default is `white`

#### `barWidth`
The width of the progress bar.  Use `setBar(width:, animated:)` if you want to animate this change

The default is `5.0`

##### These values are marked as `@IBInspectable`, and can be changed in Interface Builder

##Values

#### `currentProgress`
The current progress of the view.  **(read-only)**

#### `static completionAnimationTime`
The time it takes for the animation to run when `finish(_:)` is called.  Use this value to know how long to delay execution of any other animations that might overlap the completion.  **(read-only)**

#### `static preferredHumanDelay`
A small buffer to be appended to the end of `completionAnimationTime` to allow for the viewing of the finialized state after all animations have completed.  **(read-only)**

## Methods

#### `start(automaticallyShow:)`
Rotate the circular notched bar around in an infinite circle.  Use this method for indefinite load times.  Specify a boolean to tell the view whether or not you intend on controlling the alpha yourself.  The alpha change is not animated

* `automaticallyShow` - Whether to automatically display the progress bar or not.  Set to `false` or leave blank if you intend on using your own code to modify the alpha of this view

#### `stop(automaticallyHide:)`
Stop rotating the circular notched bar around in an infinite circle.  Use this method to pause the rotation.  Specify a boolean to tell the view whether or not you intend on controlling the alpha yourself.  The alpha change is not animated.  If `start(_:)` was not called, this method does nothing

* `automaticallyHide` - Whether to automatically hide the progress bar or not.  Set to `false` or leave blank if you intend on using your own code to modify the alpha of this view

#### `finish(_:)`
Immediately terminates the progress view's indefinite or definite loading states, telling MSProgressView how to respond to the completion. The change in state is animated.  You can use the class variable `completionAnimationTime` to receive the time interval for the animation to delay execution of any other animations that might overlap the completion

* `completion` - The state of completion in which the view should should reflect.  Refer to documentation for `MSProgressViewCompletion` for more information

#### `reset()`
Immediately terminates the progress view's state and resets the view back to its original state

### Setters

#### `setBar(color:, animated:)`
Set the rotating and progress bar color

* `color` - The color to set the bar to
* `animated` - Whether or not the color change should be animated

#### `setBar(width:, animated:)`
Set the rotating and progress bar width

* `width` - The width to set the bar to
* `animated` - Whether or not the width change should be animated

#### `setProgress(_:)`
Presents a growing circular progress bar on the view.  Use this method for definite load times.  If you called `start(_:)` or `stop(_:)` before this method, it will automatically remove the indefinite loading bar.  This method does nothing if `finish(_:)` has been called.

## Enums

### MSProgressViewCompletion
Constants indicating the type of completion

#### `success`
Displays a green circle with a checkmark

#### `failure`
Displays a red circle with an "✕"
