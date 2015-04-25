//
//  MSProgressView.swift
//  Michael Schloss
//
//  Created by Michael Schloss on 4/22/15.
//  Copyright (c) 2015 Michael Schloss. All rights reserved.
//

import UIKit

class MSProgressView: UIView
{
    ///The color of the progress bar.  Setting this value will automatically animate the color change
    ///
    ///The default color is white.
    var barColor : UIColor!
        {
        get
        {
            return hiddenBarColor
        }
        set
        {
            hiddenBarColor = newValue
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.progressLayer.strokeColor = newValue.CGColor
            })
        }
    }
    private var hiddenBarColor = UIColor.whiteColor()
    
    ///The width of the progress bar.  Setting this value will automatically animate the width change
    ///
    ///The default width is 5.0
    var barWidth : CGFloat!
        {
        get
        {
            return hiddenBarWidth
        }
        set
        {
            hiddenBarWidth = newValue
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.progressLayer.lineWidth = newValue
            })
        }
    }
    private var hiddenBarWidth : CGFloat = 5.0
    
    private var progressLayer : CAShapeLayer!
    private var progressBar: UIBezierPath!
    private var progress : CGFloat = 0.0
    
    override func drawRect(rect: CGRect)
    {
        progressBar = UIBezierPath(arcCenter: CGPointMake(progressLayer.bounds.size.width/2.0, progressLayer.bounds.height/2.0), radius: rect.size.width/2.0, startAngle: 0.0, endAngle: CGFloat(2.0 * M_PI), clockwise: YES)
        progressLayer.path = progressBar.CGPath
        layer.addSublayer(progressLayer)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = .clearColor()
        layer.backgroundColor = UIColor.clearColor().CGColor
        
        progressLayer = CAShapeLayer()
        progressLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height)
        progressLayer.strokeColor = hiddenBarColor.CGColor
        progressLayer.fillColor = UIColor.clearColor().CGColor
        progressLayer.lineWidth = hiddenBarWidth
        progressLayer.strokeEnd = 0.9
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        progressLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height)
        progressLayer.anchorPoint = CGPointMake(0.0, 0.0)
    }
    
    func startAnimating()
    {
        alpha = 1.0
        let rotationAnimation = CABasicAnimation(keyPath: "transform")
        rotationAnimation.delegate = self
        rotationAnimation.fromValue = NSValue(CATransform3D: CATransform3DRotate(layer.transform, 0.0, 0.0, 0.0, 0.0))
        rotationAnimation.toValue = NSValue(CATransform3D: CATransform3DRotate(layer.transform, CGFloat(M_PI - 0.001), 0.0, 0.0, 1.0))
        rotationAnimation.fillMode = kCAFillModeForwards
        rotationAnimation.duration = 0.5
        rotationAnimation.removedOnCompletion = NO
        layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        layer.transform = CATransform3DRotate(layer.transform, CGFloat(M_PI - 0.001), 0.0, 0.0, 1.0)
    }
    
    func stopAnimating()
    {
        alpha = 0.0
        layer.removeAnimationForKey("rotationAnimation")
    }
    
    func setProgress(newProgress: CGFloat)
    {
        alpha = 1.0
        if layer.animationForKey("rotationAnimation") != nil
        {
            layer.removeAnimationForKey("rotationAnimation")
            UIView.animateWithDuration(0.2, delay: 0.0, options: .AllowAnimatedContent | .AllowUserInteraction, animations: { () -> Void in
                self.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI * 3.0/2.0), 0.0, 0.0, 1.0)
                }, completion: nil)
        }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progress
        animation.toValue = newProgress
        animation.duration = 0.3
        animation.fillMode = kCAFillModeForwards
        progressLayer.addAnimation(animation, forKey: "strokeEndChange")
        progress = newProgress
        progressLayer.strokeEnd = newProgress
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool)
    {
        if flag == NO || layer.animationForKey("rotationAnimation") == nil
        {
            return
        }
        
        if layer.animationForKey("rotationAnimation") == anim
        {
            layer.removeAnimationForKey("rotationAnimation")
            startAnimating()
        }
    }
}
