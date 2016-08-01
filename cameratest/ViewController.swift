//
//  ViewController.swift
//  cameratest
//
//  Created by Samuel Damashek on 7/11/16.
//  Copyright © 2016 Samuel Damashek. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var studentIDField : UITextField!
    let model = cameratestModel(fcpsUserId: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func studentIDChanged(sender : AnyObject) {
        model.fcpsUserId = Int(studentIDField.text!)!
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "testRunSegue" {
            if let destination = segue.destinationViewController as? ViewController2 {
                destination.model = model
            }
        }
    }

}

class VideoDelegate : NSObject, AVCaptureFileOutputRecordingDelegate {
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        print("Finish")
    }
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        print("Start")
    }
}

class ViewController2: UIViewController {
    @IBOutlet var scoreResultLabel : UILabel!
    @IBOutlet var animationView : UIView!
    var model: cameratestModel!
    var captureSession : AVCaptureSession!
    var captureDevice : AVCaptureDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loaded view.")
        setupAnimation()
        
        captureSession = AVCaptureSession()
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if device.hasMediaType(AVMed21iaTypeVideo) {
                if device.position == AVCaptureDevicePosition.Back {
                    guard let device = device as? AVCaptureDevice else {
                        print("Doesn't exist")
                        return;
                    }
                    captureDevice = device
                    captureDevice.activeVideoMaxFrameDuration = CMTimeMake(1, 120)
                    captureDevice.activeVideoMinFrameDuration = CMTimeMake(1, 120)
                    beginCapture()
                }
            }
        }
        
        /*scoreResultLabel.text = "Calculated score: \(model.generateScore())"
        myCamera = CvVideoCamera(parentView: imageView)
        myCamera.delegate = self
        self.videoCameraWrapper = CvVideoCameraWrapper(controller:self, andImageView:imageView)
        // Do any additional setup after loading the view, typically from a nib.*/
    }
    
    func beginCapture() {
        var input:AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            print("Error with device input")
            return
        }
        
        captureSession.addInput(input)
        
        let movieFileOutput = AVCaptureMovieFileOutput()
        captureSession.addOutput(movieFileOutput)
        
        movieFileOutput.maxRecordedDuration = CMTimeMake(Int64(30 * 120), 120)
        
        let fileManager = NSFileManager()
        let path = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!.path!.stringByAppendingString("/record.mp4")
        captureSession.commitConfiguration()
        captureSession.startRunning()
        let url = NSURL(fileURLWithPath: path)
        let videoDelegate = VideoDelegate()
        movieFileOutput.startRecordingToOutputFileURL(url, recordingDelegate: videoDelegate)
        
    }
    
    func setupAnimation() {
        
        let radius = CGFloat(100)
        let circleLayer = CAShapeLayer()
        let circle = CGRectMake(0, 0, radius, radius)
        circleLayer.frame = circle
        circleLayer.backgroundColor = UIColor.clearColor().CGColor
        circleLayer.fillColor = UIColor.blackColor().CGColor
        circleLayer.path = CGPathCreateWithEllipseInRect(circle, nil)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(CGPoint: CGPointMake(0.0, 0.0))
        animation.toValue = NSValue(CGPoint: CGPointMake(0.0, 190.0))
        animation.repeatCount = 10
        animation.duration = 10
        circleLayer.addAnimation(animation, forKey: "move")
        animationView.layer.addSublayer(circleLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
