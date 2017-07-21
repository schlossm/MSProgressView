//
//  MSProgressView.swift
//
//
//  Created by Michael Schloss on 4/22/15.
//  Copyright (c) 2015 Michael Schloss. All rights reserved.
//

import UIKit

private extension UIColor
{
    ///Returns a `UIColor` object which each RGB property increased by 0.1
    var lighter : UIColor
    {
        var alpha : CGFloat = 0.0
        var red : CGFloat = 0.0
        var green : CGFloat = 0.0
        var blue : CGFloat = 0.0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: red + 0.1, green: green + 0.1, blue: blue + 0.1, alpha: alpha)
    }
}

///Constants indicating the type of completion
public enum MSProgressViewCompletion
{
    ///Displays a green circle with a checkmark
    case success
    
    ///Displays a red circle with an "✕"
    case failure
    
    public static func fromBool(bool: Bool) -> MSProgressViewCompletion
    {
        return bool ? success : failure
    }
}

@IBDesignable public class MSProgressView : UIView
{
    /**
     The color of the progress bar.  Use `setBar(color:, _:)` if you want to animate this change
     
     The default color is white.
     */
    @IBInspectable public var barColor : UIColor = .white
    {
        didSet
        {
            progressLayer.strokeColor = barColor.cgColor
        }
    }
    
    /**
     The width of the progress bar.  Use `setBar(width:, _:)` if you want to animate this change
     
     The default width is 5.0
     */
    @IBInspectable public var barWidth : CGFloat = 5.0
    {
        didSet
        {
            progressLayer.lineWidth = barWidth
        }
    }
    
    /**
     The current progress of the view.
     
     **(read-only)**
     */
    public var currentProgress : CGFloat
    {
        return progress
    }
    
    ///The time it takes for the animation to run when `finish(_:)` is called.  Use this value to know how long to delay execution of any other animations that might overlap the completion
    public static let completionAnimationTime : TimeInterval = 1.0
    
    ///A small buffer to be appended to the end of `completionAnimationTime` to allow for the viewing of the finialized state after all animations have completed
    public static let preferredHumanDelay : TimeInterval = 0.5
    
    ///A convenience variable to get the full wait time after you call `finish(_:)`.  Returns `completionAnimationTime` + `preferredHumanDelay`
    public static var fullWaitTimeAfterFinish : TimeInterval
    {
        return completionAnimationTime + preferredHumanDelay
    }
    
    //Internal Use Variables
    fileprivate var progressLayer : CAShapeLayer!
    fileprivate var progressBar : UIBezierPath!
    fileprivate var progress : CGFloat = 0.0
    fileprivate var isComplete = false
    fileprivate var isRotating = false
    
    public init()
    {
        super.init(frame: .zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //Private init stuff.  Basically sets background colors and builds the circular ring
    private func commonInit()
    {
        backgroundColor = .clear
        layer.backgroundColor = UIColor.clear.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        progressLayer = CAShapeLayer()
        progressLayer.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        progressLayer.strokeColor = barColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = barWidth
        progressLayer.strokeEnd = 0.9
    }
    
    override public func draw(_ rect: CGRect)
    {
        progressBar = UIBezierPath(arcCenter: CGPoint(x: progressLayer.bounds.size.width/2.0, y: progressLayer.bounds.height/2.0), radius: rect.size.width/2.0 - 2.0, startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        progressLayer.path = progressBar.cgPath
        layer.addSublayer(progressLayer)
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        progressLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        //progressLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //progressLayer.position = CGPoint(x: bounds.size.width/2.0, y: bounds.size.height/2.0)
    }
    
    /**
     Rotate the circular notched bar around in an infinite circle.  Use this method for indefinite load times.  Specify a boolean to tell the view whether or not you intend on controlling the presentation yourself
     
     If you specify `true`, the presentation is not animated
     
     - Parameter automaticallyShow: Whether to automatically display the progress bar or not.  Set to `false` or leave blank if you intend on using your own code to present this view
     */
    public func start(automaticallyShow: Bool = false)
    {
        guard !isComplete && !isRotating else { return }
        isRotating = true
        
        if automaticallyShow == true { alpha = 1.0 }
        
        addAnimationForRotation()
    }
    
    /**
     Stop rotating the circular notched bar.  Use this method to pause the rotation.  Specify a boolean to tell the view whether or not you intend on controlling the dismissal yourself
     
     If you specify `true`, the dismissal is not animated.  The dismissal does not remove the view from its superview
     
     If `start(_:)` was not called, or if `setProgress(_:)` was called, this method does nothing
     
     - Parameter automaticallyHide: Whether to automatically hide the progress bar or not.  Set to `false` or leave blank if you intend on using your own code to dismiss this view
     */
    public func stop(automaticallyHide: Bool = false)
    {
        guard !isComplete && isRotating else { return }
        isRotating = false
        
        if automaticallyHide == true { alpha = 0.0; }
        
        progressLayer.removeAnimation(forKey: "rotationAnimation")
    }
    
    /**
     Immediately terminates the progress view's loading state, and responds to the specified completion state
     
     The change in state is animated.  You can use the class variable `completionAnimationTime` to obtain the time interval for the animation to delay execution of any other animations that might overlap
     
     - Parameter completion: The state of completion in which the progress view should should reflect.  Refer to `MSProgressViewCompletion`'s documentation for more information
     */
    public func finish(_ completion: MSProgressViewCompletion)
    {
        switch completion
        {
        case .success:
            success()
            
        case .failure:
            failure()
        }
    }
    
    /**
     Immediately terminates the progress view's state and resets the view back to its original state.
     
     The change is not animated
     */
    public func reset()
    {
        progressLayer.opacity = 1.0
        progressBar = UIBezierPath(arcCenter: CGPoint(x: progressLayer.bounds.size.width/2.0, y: progressLayer.bounds.height/2.0), radius: frame.size.width/2.0 - 2.0, startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        progressLayer.path = progressBar.cgPath
        isComplete = false
        isRotating = false
        
        for subview in subviews
        {
            subview.removeFromSuperview()
        }
    }
    
    //MARK: - Setters
    
    /**
     Set the progress bar's color
     
     - Parameter color: The new color
     - Parameter flag: Whether or not the color change should be animated
     */
    public func setBar(color: UIColor, animated flag: Bool = false)
    {
        let color = progressLayer.strokeColor
        progressLayer.strokeColor = barColor.cgColor
        
        guard flag else { return }
        
        let barColorAnimation = CABasicAnimation(keyPath: "lineWidth")
        barColorAnimation.fromValue = NSValue(nonretainedObject: color)
        barColorAnimation.toValue = NSValue(nonretainedObject: barColor.cgColor)
        barColorAnimation.fillMode = kCAFillModeForwards
        barColorAnimation.duration = 0.5
        barColorAnimation.isRemovedOnCompletion = false
        progressLayer.add(barColorAnimation, forKey: "barColorAnimation")
    }
    
    /**
     Set the progress bar's width
     
     - Parameter width: The new width
     - Parameter flag: Whether or not the width change should be animated
     */
    public func setBar(width: CGFloat, animated flag: Bool = false)
    {
        let lineWidth = progressLayer.lineWidth
        progressLayer.lineWidth = barWidth
        
        guard flag else { return }
        
        let barWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        barWidthAnimation.fromValue = lineWidth
        barWidthAnimation.toValue = barWidth
        barWidthAnimation.fillMode = kCAFillModeForwards
        barWidthAnimation.duration = 0.5
        barWidthAnimation.isRemovedOnCompletion = false
        progressLayer.add(barWidthAnimation, forKey: "barWidthAnimation")
    }
    
    /**
     Presents a growing circular progress bar on the view.  Use this method for definite load times
     
     If the progress view is showing an indefinite load, the circular bar will be removed and replaced
     
     If `finish(_:)` was called, this method does nothing
     
     - Parameter newProgress: The total progress the view should reflect.  The change in progress is animated
     */
    public func setProgress(_ newProgress: CGFloat)
    {
        guard !isComplete else { return }
        
        if isRotating
        {
            isRotating = false
            progressLayer.removeAnimation(forKey: "rotationAnimation")
            if #available(iOS 10.0, *)
            {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .allowAnimatedContent], animations: { [weak self] in
                    self?.progressLayer.transform = CATransform3DMakeRotation(CGFloat.pi * 3.0/2.0, 0.0, 0.0, 1.0)
                    }, completion: nil)
            }
            else
            {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .allowAnimatedContent], animations: { [weak self] in
                    self?.progressLayer.transform = CATransform3DMakeRotation(CGFloat.pi * 3.0/2.0, 0.0, 0.0, 1.0)
                    }, completion: nil)
            }
        }
        
        progressLayer.add(makeSpringAnimation(for: "strokeEnd", fromValue: progress, toValue: newProgress), forKey: nil)
        progress = newProgress
        progressLayer.strokeEnd = newProgress
    }
}

//MARK: - Helper methods

private extension MSProgressView
{
    func success()
    {
        guard !isComplete else { return }
        isComplete = true
        isRotating = false
        
        let successView = makeCompleteView(with: UIColor.green.lighter)
        
        let successBezierPath = UIBezierPath()
        successBezierPath.lineCapStyle = .round
        successBezierPath.move(to: CGPoint(x: 0.27083 * frame.width, y: 0.54167 * frame.height))
        successBezierPath.addLine(to: CGPoint(x: 0.41667 * frame.width, y: 0.68750 * frame.height))
        successBezierPath.addLine(to: CGPoint(x: 0.75000 * frame.width, y: 0.35417 * frame.height))
        
        let successShapeLayer = makeShapeLayer(with: successBezierPath)
        successView.layer.addSublayer(successShapeLayer)
        successShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        UIView.performWithoutAnimation {
            layoutIfNeeded()
            successView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }
        
        let animations = {
            successView.transform = CGAffineTransform.identity
        }
        
        let completion : (Any) -> Void = { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.progressLayer.removeAnimation(forKey: "rotationAnimation")
            successShapeLayer.add(weakSelf.makeSpringAnimation(for: "strokeStart", fromValue: 0.5, toValue: 0.0), forKey: nil)
            successShapeLayer.add(weakSelf.makeSpringAnimation(for: "strokeEnd", fromValue: 0.5, toValue: 1.0), forKey: nil)
            
            successShapeLayer.strokeStart = 0.0
            successShapeLayer.strokeEnd = 1.0
        }
        
        if #available(iOS 10.0, *)
        {
            let animator = UIViewPropertyAnimator(duration: MSProgressView.completionAnimationTime, dampingRatio: 0.6, animations: animations)
            animator.addCompletion(completion)
            animator.startAnimation()
        }
        else
        {
            UIView.animate(withDuration: MSProgressView.completionAnimationTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.allowAnimatedContent], animations: animations, completion: completion)
        }
    }
    
    func failure()
    {
        guard !isComplete else { return }
        isComplete = true
        isRotating = false
        
        let failureView = makeCompleteView(with: UIColor.red.lighter)
        
        let firstBezierPath = UIBezierPath()
        firstBezierPath.lineCapStyle = .round
        firstBezierPath.move(to: CGPoint(x: 0.27083 * frame.width, y: 0.27083 * frame.height))
        firstBezierPath.addLine(to: CGPoint(x: 0.72917 * frame.width, y: 0.72917 * frame.height))
        
        let secondBezierPath = UIBezierPath()
        secondBezierPath.lineCapStyle = .round
        secondBezierPath.move(to: CGPoint(x: 0.27083 * frame.width, y: 0.72917 * frame.height))
        secondBezierPath.addLine(to: CGPoint(x: 0.72917 * frame.width, y: 0.27083 * frame.height))
        
        let firstFailureViewShapeLayer = makeShapeLayer(with: firstBezierPath)
        failureView.layer.addSublayer(firstFailureViewShapeLayer)
        firstFailureViewShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        let secondFailureViewShapeLayer = makeShapeLayer(with: secondBezierPath)
        failureView.layer.addSublayer(secondFailureViewShapeLayer)
        secondFailureViewShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        UIView.performWithoutAnimation {
            layoutIfNeeded()
            failureView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2).concatenating(CGAffineTransform(scaleX: 0.0, y: 0.0))
        }
        
        let animations = {
            failureView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2.0)
        }
        
        let completion : (Any) -> Void = { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.progressLayer.removeAnimation(forKey: "rotationAnimation")
            
            firstFailureViewShapeLayer.add(weakSelf.makeSpringAnimation(for: "stokeStart", fromValue: 0.5, toValue: 0.0), forKey: nil)
            firstFailureViewShapeLayer.add(weakSelf.makeSpringAnimation(for: "strokeEnd", fromValue: 0.5, toValue: 1.0), forKey: nil)
            secondFailureViewShapeLayer.add(weakSelf.makeSpringAnimation(for: "strokeStart", fromValue: 0.5, toValue: 0.0), forKey: nil)
            secondFailureViewShapeLayer.add(weakSelf.makeSpringAnimation(for: "strokeEnd", fromValue: 0.5, toValue: 1.0), forKey: nil)
            
            secondFailureViewShapeLayer.strokeStart = 0.0
            firstFailureViewShapeLayer.strokeEnd = 1.0
            firstFailureViewShapeLayer.strokeStart = 0.0
            secondFailureViewShapeLayer.strokeEnd = 1.0
        }
        
        if #available(iOS 10.0, *)
        {
            let animator = UIViewPropertyAnimator(duration: MSProgressView.completionAnimationTime, dampingRatio: 0.6, animations: animations)
            animator.addCompletion(completion)
            animator.startAnimation()
        }
        else
        {
            UIView.animate(withDuration: MSProgressView.completionAnimationTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.allowAnimatedContent], animations: animations, completion: completion)
        }
    }
    
    func addAnimationForRotation()
    {
        let transform = progressLayer.transform
        progressLayer.transform = CATransform3DRotate(progressLayer.transform, CGFloat.pi - 0.001, 0.0, 0.0, 1.0)
        let rotationAnimation = CABasicAnimation(keyPath: "transform")
        rotationAnimation.fromValue = NSValue(caTransform3D: transform)
        rotationAnimation.toValue = NSValue(caTransform3D: CATransform3DRotate(transform, CGFloat.pi - 0.001, 0.0, 0.0, 1.0))
        rotationAnimation.fillMode = kCAFillModeForwards
        rotationAnimation.isAdditive = true
        rotationAnimation.duration = 0.5
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.repeatCount = .greatestFiniteMagnitude
        progressLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func makeSpringAnimation(for keyPath: String, fromValue: Any, toValue: Any) -> CASpringAnimation
    {
        let animation = CASpringAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.mass = 0.1
        animation.duration = animation.settlingDuration
        return animation
    }
    
    func makeShapeLayer(with path: UIBezierPath) -> CAShapeLayer
    {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.strokeStart = 0.5
        shapeLayer.strokeEnd = 0.5
        return shapeLayer
    }
    
    func makeCompleteView(with color: UIColor) -> UIView
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        addSubview(view)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":view]) + NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":view]))
        view.layer.cornerRadius = frame.size.width/2.0
        
        return view
    }
}