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
    private var progress = Progress()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progressObject = progress
    }
    
    @IBAction func startProgressView()
    {
        progressView.start()
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
        progress.totalUnitCount = 10
        progress.completedUnitCount = Int64(stepper.value) % 11
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

