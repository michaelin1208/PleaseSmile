//
//  ViewController.swift
//  PleaseSmile
//
//  Created by Michaelin on 15/11/30.
//  Copyright © 2015年 Michaelin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var stillImageOutput:AVCaptureStillImageOutput?
    var audioPlayer:AVAudioPlayer?
    
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var laughBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Add image output into the session.
        stillImageOutput = AVCaptureStillImageOutput()
        let outputSettings = NSDictionary(object: AVVideoCodecJPEG, forKey: AVVideoCodecKey)
        stillImageOutput?.outputSettings = outputSettings as! [NSObject : AnyObject]
        captureSession?.addOutput(stillImageOutput)
        
        // Initialize the audio player to play the laughing sounds.
        let path = NSBundle.mainBundle().URLForResource("laugh1", withExtension: "mp3")
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: path!)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            print("\(error?.localizedDescription)")
            return
        }
        
        // Move the message label and navigation bar to the top view
        view.bringSubviewToFront(takePhotoBtn)
        view.bringSubviewToFront(laughBtn)
        
        // Start video capture.
        captureSession?.startRunning()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // the touched action of take photo button, it will take photo.
    @IBAction func takePhoto(sender: AnyObject) {
        var returnImage = UIImage()
        //get connection
        var videoConnection:AVCaptureConnection?
        for connection in (stillImageOutput?.connections)! {
            for port in (connection.inputPorts)! {
                if (port.mediaType == AVMediaTypeVideo) {
                    videoConnection = connection as? AVCaptureConnection;
                    break;
                }
            }
            if ((videoConnection) != nil) {
                break;
            }
        }
        
        
        //get UIImage
        stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: 
            {(imageSampleBuffer, error) -> Void in
            // Continue as appropriate.
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
            let t_image = UIImage(data: imageData)
            returnImage = UIImage(CGImage: t_image!.CGImage!, scale: 1.0, orientation: UIImageOrientation.Right)
            UIImageWriteToSavedPhotosAlbum(returnImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
        })
    }

    // the touched action of laugh, it will play laughing sound.
    @IBAction func startLaugh(sender: AnyObject) {
        audioPlayer?.play()
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        print("---")
        
        if didFinishSavingWithError != nil {
            print("错误")
            return
        }
        print("OK")
    }
}

