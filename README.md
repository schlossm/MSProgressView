# MSProgressView
### A simple, circular Progress Indicator with completion success/error feedback

[![Build Status](https://app.bitrise.io/app/689896f44cca4b39/status.svg?token=2gKpITGv4XFVtfhDXbfBag&branch=master)](https://app.bitrise.io/app/689896f44cca4b39)

**NOTE:** MSProgressView is written in Swift 5.  This requires Xcode 10.2+

## Setup

### Manual Setup
1. To use MSProgressView, download `MSProgressView.swift` and drag it into Xcode
2. That's it.  If you are writing your project in Objective-C, you will have to import `XXX-Swift.h` into your `.m` file, where `XXX` is your project's name

### CocoaPods
`MSProgressView` is available on CocoaPods as `MSCircularProgressView`

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

**Note:** MSProgressView is marked @IBDesignable.  You can initialize in Interface Builder as well and customize some of the below Options

## Options
MSProgressView is completely customizable.  For quick setup, two variables have been provided for you

#### `barColor`
The color of the progress bar.  Use `setBar(color:, animated:)` if you want to animate this change

The default is `white`

#### `barWidth`
The width of the progress bar.  Use `setBar(width:, animated:)` if you want to animate this change

The default is `5.0`

##### The previous options are marked as `@IBInspectable`, and can be changed in Interface Builder

#### `progressObject`
You can optionally attach a `Progress` object to `MSProgressView`

As you update the `totalUnitCount` and/or `completedUnitCount`, `MSProgressView` will automatically update its display

- **Important**: If `isIndeterminate` evaluates to true, `MSProgressView` will not update in response to changes in properties

## Values

#### `currentProgress`
The current progress of the view.  **(read-only)**

#### `static completionAnimationTime`
The time it takes for the animation to run when `finish(_:)` is called.  Use this value to know how long to delay execution of any other animations that might overlap the completion.  **(read-only)**

#### `static preferredHumanDelay`
A small buffer to be appended to the end of `completionAnimationTime` to allow for the viewing of the finialized state after all animations have completed.  **(read-only)**

## Methods

#### `start()`
Rotate the circular notched bar around in an infinite circle.  Use this method for indefinite load times

If any of the following methods were called, this method does nothing:
* `setProgress(_:animated:)`
* `finish(_:animated:)`

#### `stop()`
Stop rotating the circular notched bar around in an infinite circle.  Use this method to pause the rotation

If any of the following methods were called, this method does nothing:
* `start()`
* `setProgress(_:animated:)`
* `finish(_:animated:)`

#### `finish(_:)`
Immediately terminates the progress view's loading state, and responds to the specified completion state

The change in state is animated.  You can use the class variable `completionAnimationTime` to obtain the time interval for the animation to delay execution of any other animations that might overlap

- `completion`: The state of completion in which the progress view should should reflect.  Refer to `MSProgressViewCompletion`'s documentation for more information
- `animated`: Whether or not the display should be animated

#### `reset()`
Immediately terminates the progress view's state and resets the view back to its original state.

After calling `reset`, you can call any other methods (for example when restarting a download).  The reset is not animated

- Note: MSProgressView does **not** lose its attachment to the given `progressObject`, if one was supplied

### Setters

#### `setBar(color:, animated:)`
Set the rotating and progress bar color

* `color` - The color to set the bar to
* `animated` - Whether or not the color change should be animated

#### `setBar(width:, animated:)`
Set the rotating and progress bar width

* `width` - The width to set the bar to
* `animated` - Whether or not the width change should be animated

#### `setProgress(_:animated:)`
Presents a growing circular progress bar on the view.  Use this method for definite load times

If the progress view is showing an indefinite load, the circular bar will be removed and replaced

If `finish(_:animated:)` was called, this method does nothing

- `newProgress`: The total progress the view should reflect
- `animated`: Whether or not the progress change should be animated.  Defaults to `true`

## Enums

### MSProgressViewCompletion
Constants indicating the type of completion

#### `success`
Displays a green circle with a checkmark

#### `failure`
Displays a red circle with an "✕"

# Changelog

### 1.2.0
* Improved `Progress` object tracking
* Improved success and failure colors to be less contrasting
* Removing `MSProgressView` from its superview will now automatically stop any animations
* You can now disable animations on any call (except when using a `Progress` object)
* `MSProgressView` is now subclass-able
* Moved the progress increment animation to use `UIViewPropertyAnimator`.  This provides interruptable progress changes, which previously would result in jarring animation jumps
