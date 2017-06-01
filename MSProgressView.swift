//
//  MSProgressView.swift
//
//
//  Created by Michael Schloss on 4/22/15.
//  Copyright (c) 2015 Michael Schloss. All rights reserved.
//

import UIKit

extension UIColor
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

//Constants indicating the type of completion
enum MSProgressViewCompletion
{
    ///Displays a green circle with a checkmark
    case success
    
    ///Displays a red circle with an "✕"
    case failure
}

@IBDesignable class MSProgressView: UIView, CAAnimationDelegate
{
    /**
     The color of the progress bar.  Use `setBar(_: UIColor, _:)` if you want to animate this change
     
     The default color is white.
     */
    @IBInspectable var barColor : UIColor = .white
        {
        didSet
        {
            progressLayer.strokeColor = barColor.cgColor
        }
    }
    
    /**
     The width of the progress bar.  Use `setBar(_: CGFloat, _:)` if you want to animate this change
     
     The default width is 5.0
     */
    @IBInspectable var barWidth : CGFloat = 5.0
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
    var currentProgress : CGFloat
    {
        get
        {
            return progress
        }
    }
    
    ///The time it takes for the animation to run when `finish(_:)` is called.  Use this value to know how long to delay execution of any other animations that might overlap the completion
    static let completionAnimationTime : TimeInterval = 1.0
    
    ///A small buffer to be appended to the end of `completionAnimationTime` to allow for the viewing of the finialized state after all animations have completed
    static let preferredHumanDelay : TimeInterval = 0.8
    
    //Internal Use Variables
    fileprivate var progressLayer : CAShapeLayer!
    fileprivate var progressBar: UIBezierPath!
    fileprivate var progress : CGFloat = 0.0
    fileprivate var isComplete = false
    fileprivate var isRotating = false
    
    ///Initializes `MSProgressview` with a `(x: 0, y: 0, width: 0, height: 0)` frame and sets `translatesAutoresizingMaskIntoConstraints` to false.  Use this initializer for AutoLayout
    init()
    {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //Private init stuff.  Basically sets background colors and builds the circular ring
    private func commonInit()
    {
        backgroundColor = .clear
        layer.backgroundColor = UIColor.clear.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.bounds = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        progressLayer.strokeColor = barColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = barWidth
        progressLayer.strokeEnd = 0.9
    }
    
    override func draw(_ rect: CGRect)
    {
        progressBar = UIBezierPath(arcCenter: CGPoint(x: progressLayer.bounds.size.width/2.0, y: progressLayer.bounds.height/2.0), radius: rect.size.width/2.0 - 2.0, startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        progressLayer.path = progressBar.cgPath
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        progressLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        progressLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        progressLayer.position = CGPoint(x: bounds.size.width/2.0, y: bounds.size.height/2.0)
    }
    
    /**
     Rotate the circular notched bar around in an infinite circle.  Use this method for indefinite load times.  Specify a boolean to tell the view whether or not you intend on controlling the alpha yourself.  The alpha change is not animated
     
     - Parameter show: Whether to automatically display the progress bar or not.  Set to `false` or leave blank if you intend on using your own code to modify the alpha of this view
     */
    func start(show: Bool = false)
    {
        guard !isComplete && !isRotating else { return }
        isRotating = true
        
        if show == true { alpha = 1.0 }
        
        addAnimationForRotation()
    }
    
    /**
     Stop rotating the circular notched bar around in an infinite circle.  Use this method to pause the rotation.  Specify a boolean to tell the view whether or not you intend on controlling the alpha yourself.  The alpha change is not animated
     
     If `start(_:)` was not called, this method does nothing
     
     - Parameter show: Whether to automatically hide the progress bar or not.  Set to `false` or leave blank if you intend on using your own code to modify the alpha of this view
     */
    func stop(show: Bool = false)
    {
        guard !isComplete && isRotating else { return }
        isRotating = false
        
        if show == true { alpha = 0.0 }
        
        progressLayer.removeAnimation(forKey: "rotationAnimation")
    }
    
    /**
     Immediately terminates the progress view's indefinite or definite loading states, telling MSProgressView how to respond to the completion
     
     The change in state is animated.  You can use the class variable `completionAnimationTime` to receive the time interval for the animation to delay execution of any other animations that might overlap the completion
     
     - Parameter completion: The state of completion in which the view should should reflect.  Refer to documentation for `MSProgressViewCompletion` for more information
     */
    func finish(_ completion: MSProgressViewCompletion)
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
     Immediately terminates the progress view's state and resets the view back to its original state
     */
    func reset()
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
     Set the rotating and progress bar color
     
     - Parameter color: The color to set the bar to
     - Parameter flag: Whether or not the color change should be animated
     */
    func setBar(color: UIColor, animated flag: Bool = false)
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
     Set the rotating and progress bar width
     
     - Parameter width: The width to set the bar to
     - Parameter flag: Whether or not the width change should be animated
     */
    func setBar(width: CGFloat, animated flag: Bool = false)
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
     Presents a growing circular progress bar on the view.  Use this method for definite load times.  If you called `startAnimating(_:)` or `stopAnimating(_:)` before this method, it will automatically stop and remove the indefinite loading bar
     
     - Parameter newProgress: The progress to set the bar to.  This property is **not** additive
     */
    func setProgress(_ newProgress: CGFloat)
    {
        guard !isComplete else { return }
        
        if isRotating
        {
            isRotating = false
            progressLayer.removeAnimation(forKey: "rotationAnimation")
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction, .allowAnimatedContent], animations: { [unowned self] in
                self.progressLayer.transform = CATransform3DMakeRotation(CGFloat.pi * 3.0/2.0, 0.0, 0.0, 1.0)
                }, completion: nil)
        }
        
        progressLayer.add(springAnimation("strokeEnd", fromValue: progress, toValue: newProgress), forKey: nil)
        progress = newProgress
        progressLayer.strokeEnd = newProgress
    }
    
    
    //MARK: - CAAnimationDelegate Methods
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        if isRotating
        {
            addAnimationForRotation()
        }
    }
    
    
    //MARK: - Helper methods
    
    fileprivate func success()
    {
        guard !isComplete else { return }
        isComplete = true
        isRotating = false
        
        let greenView = completeView(UIColor.green.lighter)
        
        let bezierPath = UIBezierPath()
        bezierPath.lineCapStyle = .round
        bezierPath.move(to: CGPoint(x: 0.27083 * frame.width, y: 0.54167 * frame.height))
        bezierPath.addLine(to: CGPoint(x: 0.41667 * frame.width, y: 0.68750 * frame.height))
        bezierPath.addLine(to: CGPoint(x: 0.75000 * frame.width, y: 0.35417 * frame.height))
        
        let greenViewShapeLayer = shapeLayer(bezierPath)
        greenView.layer.addSublayer(greenViewShapeLayer)
        greenViewShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        layoutIfNeeded()
        greenView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animate(withDuration: MSProgressView.completionAnimationTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: [.allowUserInteraction, .allowAnimatedContent], animations: {
            greenView.transform = CGAffineTransform.identity
        }) { [unowned self] _  in
            self.progressLayer.removeAnimation(forKey: "rotationAnimation")
            greenViewShapeLayer.add(self.springAnimation("strokeStart", fromValue: 0.5, toValue: 0.0), forKey: nil)
            greenViewShapeLayer.add(self.springAnimation("strokeEnd", fromValue: 0.5, toValue: 1.0), forKey: nil)
            
            greenViewShapeLayer.strokeStart = 0.0
            greenViewShapeLayer.strokeEnd = 1.0
        }
    }
    
    fileprivate func failure()
    {
        guard isComplete == false else { return }
        isComplete = true
        isRotating = false
        
        let redView = completeView(UIColor.red.lighter)
        
        let firstBezierPath = UIBezierPath()
        firstBezierPath.lineCapStyle = .round
        firstBezierPath.move(to: CGPoint(x: 0.27083 * frame.width, y: 0.27083 * frame.height))
        firstBezierPath.addLine(to: CGPoint(x: 0.72917 * frame.width, y: 0.72917 * frame.height))
        
        let secondBezierPath = UIBezierPath()
        secondBezierPath.lineCapStyle = .round
        secondBezierPath.move(to: CGPoint(x: 0.27083 * frame.width, y: 0.72917 * frame.height))
        secondBezierPath.addLine(to: CGPoint(x: 0.72917 * frame.width, y: 0.27083 * frame.height))
        
        let firstRedViewShapeLayer = shapeLayer(firstBezierPath)
        redView.layer.addSublayer(firstRedViewShapeLayer)
        firstRedViewShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        let secondRedViewShapeLayer = shapeLayer(secondBezierPath)
        redView.layer.addSublayer(secondRedViewShapeLayer)
        secondRedViewShapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        layoutIfNeeded()
        redView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2).concatenating(CGAffineTransform(scaleX: 0.0, y: 0.0))
        
        UIView.animate(withDuration: MSProgressView.completionAnimationTime, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
            redView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2.0)
        }) { [unowned self] _ in
            self.progressLayer.removeAnimation(forKey: "rotationAnimation")
            
            firstRedViewShapeLayer.add(self.springAnimation("stokeStart", fromValue: 0.5, toValue: 0.0), forKey: nil)
            firstRedViewShapeLayer.add(self.springAnimation("strokeEnd", fromValue: 0.5, toValue: 1.0), forKey: nil)
            secondRedViewShapeLayer.add(self.springAnimation("strokeStart", fromValue: 0.5, toValue: 0.0), forKey: nil)
            secondRedViewShapeLayer.add(self.springAnimation("strokeEnd", fromValue: 0.5, toValue: 1.0), forKey: nil)
            
            secondRedViewShapeLayer.strokeStart = 0.0
            firstRedViewShapeLayer.strokeEnd = 1.0
            firstRedViewShapeLayer.strokeStart = 0.0
            secondRedViewShapeLayer.strokeEnd = 1.0
        }
    }
    
    fileprivate func addAnimationForRotation()
    {
        let transform = progressLayer.transform
        progressLayer.transform = CATransform3DRotate(progressLayer.transform, CGFloat.pi - 0.001, 0.0, 0.0, 1.0)
        let rotationAnimation = CABasicAnimation(keyPath: "transform")
        rotationAnimation.delegate = self
        rotationAnimation.fromValue = NSValue(caTransform3D: transform)
        rotationAnimation.toValue = NSValue(caTransform3D: CATransform3DRotate(transform, CGFloat.pi - 0.001, 0.0, 0.0, 1.0))
        rotationAnimation.fillMode = kCAFillModeForwards
        rotationAnimation.duration = 0.5
        rotationAnimation.isRemovedOnCompletion = false
        progressLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    fileprivate func springAnimation(_ keyPath: String, fromValue: Any, toValue: Any) -> CASpringAnimation
    {
        let animation = CASpringAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.mass = 0.1
        animation.duration = animation.settlingDuration
        animation.delegate = self
        return animation
    }
    
    fileprivate func shapeLayer(_ path: UIBezierPath) -> CAShapeLayer
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
    
    fileprivate func completeView(_ color: UIColor) -> UIView
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        addSubview(view)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":view]))
        view.layer.cornerRadius = frame.size.width/2.0
        
        return view
    }
}
