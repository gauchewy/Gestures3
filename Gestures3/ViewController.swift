//
//  ViewController.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//
import UIKit
import AVFoundation
import Vision
import CoreML


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var gestureModel: VNCoreMLModel!
    var selectedOption: SelectedOption?
    var onHandPoseDetected: (([VNHumanHandPoseObservation]) -> Void)?
    var lastInterlaceDetectionTime: Date? = nil
    var lastBinocularsDetectionTime: Date? = nil
    let gestureTimeoutInterval: TimeInterval = 0.5
    let complete: (Bool) -> Void

    init(selectedOption: SelectedOption, completion: @escaping (Bool) -> Void) {
        self.selectedOption = selectedOption
        self.complete = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    // MARK: - Variables
    private var requests = [VNRequest]()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let captureSession = AVCaptureSession()
    private var previousHandPoints = [CGPoint]()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Selected option: \(selectedOption?.rawValue ?? "None")")
        
        // Load your VNCoreMLModel here
        let config = MLModelConfiguration()
        config.computeUnits = .all
       
        setupVision()
        addCameraInput()
        showCameraFeed()
        getCameraFrames()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.frame
    }
    

    
    private func setupVision() {
        let handPoseRequest = VNDetectHumanHandPoseRequest { [weak self] request, error in
            guard let observations = request.results as? [VNHumanHandPoseObservation] else {
                return print("Error: \(error?.localizedDescription ?? "unknown error")")
            }
            
            self?.onHandPoseDetected = { observations in
//                for observation in observations {
//                    // Process each observation
//                    print("New hand pose observation detected.")
//                    print(observation)
//                }
            }
            
            // Calling the callback function here when observations are ready.
            self?.onHandPoseDetected?(observations)
            
//            // WAVE
//            if self?.selectedOption == .wave {
//        
//            }
//            
//            // BINOCULARS -- WORKS
//            if self?.selectedOption == .binoculars {
//                
//            }
//                        
//            
//            // HAND CLASP
//            if self?.selectedOption == .handClasp {
//             
//            }
//        
//                
//
//            // INTERLACE
//            if self?.selectedOption == .interlace {
//
//            }
          
        }
        self.requests.append(handPoseRequest)
    }
    
  

    // MARK: - Setup Functions
    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else {
            fatalError("No camera detected. Please use a real camera, not a simulator.")
        }

        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }
    
    private func showCameraFeed() {
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
    
    private func getCameraFrames() {
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        // You do not want to process the frames on the Main Thread so we offload to another thread
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        
        captureSession.addOutput(videoDataOutput)
        
        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }
        
        connection.videoOrientation = .portrait
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print("Failed to perform image request handler: \(error)")
            return
        }

        guard let results = self.requests[0].results as? [VNHumanHandPoseObservation] else {
            return
        }

        for observation in results {
            guard let keypointsMultiArray = try? observation.keypointsMultiArray() else {
                print("Failed to create keypointsMultiArray")
                continue
            }

            // Create an instance of your model
            let config = MLModelConfiguration()
            guard let model = try? Gestures3(configuration: config) else {
                print("Failed to create Gestures3 model")
                return
            }

            // Perform prediction using your model.
            guard let predictionOutput = try? model.prediction(poses: keypointsMultiArray) else {
                print("Failed to make prediction")
                return
            }

            // Perform actions based on the used model's prediction output.
            // Note: this prediction may differ based on your model.
            let predictedLabel = predictionOutput.label
            let confidence = predictionOutput.labelProbabilities[predictionOutput.label]!
            
            print("PREDICTION: \(predictedLabel) \(confidence)4")
            
            if predictedLabel == "Background" && confidence >= 0.9 {
                DispatchQueue.main.async {
                    self.complete(false)
                }
            }
            
            // UNSURE ABOUT THIS...need to look over
            DispatchQueue.main.async {
                
                if self.selectedOption == .binoculars && predictedLabel == "Binoculars" && confidence >= 0.50 {
                      self.lastBinocularsDetectionTime = Date()
                      self.complete(true)
                    } else {
                      // Check if specific pose hasn't been seen for a specified time interval
                      if let lastDetectionTime = self.lastBinocularsDetectionTime,
                        lastDetectionTime.timeIntervalSinceNow < -self.gestureTimeoutInterval {
                        self.complete(false)
                      }
                    }

                if self.selectedOption == .interlace && predictedLabel == "InterlaceFingers" && confidence >= 0.95 {
                     self.lastInterlaceDetectionTime = Date()
                     self.complete(true)
                   } else {
                     // Check if specific pose hasn't been seen for a specified time interval
                     if let lastDetectionTime = self.lastInterlaceDetectionTime,
                       lastDetectionTime.timeIntervalSinceNow < -self.gestureTimeoutInterval {
                       self.complete(false)
                     }
                   }
                
                 }
            
        }
    }
}
