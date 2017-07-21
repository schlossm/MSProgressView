//
//  ViewController.swift
//  MSProgressView Demo
//
//  Created by Michael Schloss on 7/19/17.
//  Copyright © 2017 Michael Schloss. All rights reserved.
//

import UIKit
import MSProgressView

class ViewController: UIViewController
{
    @IBOutlet var progressView : MSProgressView!
    
    @IBAction func startProgressView()
    {
        progressView.start(automaticallyShow: true)
    }
    
    @IBAction func stopProgressView()
    {
        progressView.stop()
    }
    
    @IBAction func reset()
    {
        progressView.reset()
    }
    
    @IBAction func setProgress(_ stepper: UIStepper)
    {
        progressView.setProgress(stepper.value/10.0)
    }
    
    @IBAction func successProgressView()
    {
        progressView.finish(.success)
    }
    
    @IBAction func failureProgressView()
    {
        progressView.finish(.failure)
    }
}

