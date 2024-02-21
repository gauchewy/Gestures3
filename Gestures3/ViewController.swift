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
    
    var gestureModel: GESTURES31!
    var selectedOption: SelectedOption?
    var onHandPoseDetected: (([VNHumanHandPoseObservation]) -> Void)?
    var lastInterlaceDetectionTime: Date? = nil
    var lastBinocularsDetectionTime: Date? = nil
    var lastSquareDetectionTime: Date? = nil
    var lastWaveDetectionTime: Date? = nil
    var delayTime: Double = 2.0
    var confLevel = 0.5 // vary this??? 
    private var falseDetectionTimer: Timer?
    private var noObservationsTriggered = false
    //let gestureTimeoutInterval: TimeInterval = 1.0
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
        
        gestureModel = loadModel()
        
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
        
        let handler: ([VNHumanHandPoseObservation]) -> Void = { observations in
            if observations.isEmpty {
                print("No hand poses detected")
                self.complete(false)
                return
            }
            
            guard let keypointsMultiArray = try? observations[0].keypointsMultiArray() else {
                print("Failed to create keypointsMultiArray")
                self.complete(false)
                return
            }
            
            guard let predictionOutput = try? self.gestureModel.prediction(poses: keypointsMultiArray) else {
                print("Failed to make prediction")
                self.complete(false)
                return
            }
            
            let predictedLabel = predictionOutput.label
            guard let confidence = predictionOutput.labelProbabilities[predictedLabel] else {
                print("Unable to retrieve confidence for \(predictedLabel)")
                self.complete(false)
                return
            }
            
            print("PREDICTION: \(predictedLabel) \(confidence)")
            
            DispatchQueue.main.async {
                // Check if the predicted gesture matches the selected gesture
                switch self.selectedOption {
                case .binoculars where predictedLabel == "Binoculars" && confidence >= self.confLevel,
                        .binoculars where predictedLabel == "InterlaceFingers" && confidence >= self.confLevel,
                        .interlace where predictedLabel == "InterlaceFingers" && confidence >= self.confLevel,
                        .frame where predictedLabel == "Square" && confidence >= self.confLevel,
                        .wave where predictedLabel == "Wave" && confidence >= self.confLevel:
                    self.falseDetectionTimer?.invalidate()
                    self.falseDetectionTimer = nil
                    self.complete(true)
                    
                default:
                    // Complete with false if no gesture is detected or if another gesture is detected
                    self.complete(false)
                    self.startOrResetFalseDetectionTimer()
                }
            }
        }
        
        
        // Define hand pose request
        let handPoseRequest = VNDetectHumanHandPoseRequest(completionHandler: {(request, error) in
            guard let observations = request.results as? [VNHumanHandPoseObservation] else {
                return print("Error: \(error?.localizedDescription ?? "unknown error")")
            }
            handler(observations)
        })
        
        self.requests.append(handPoseRequest)
    }
    
    
    private func startOrResetFalseDetectionTimer() {
        // Invalidate and nullify any existing timer
        self.falseDetectionTimer?.invalidate()
        self.falseDetectionTimer = nil
        
        // Start a new timer
        self.falseDetectionTimer = Timer.scheduledTimer(withTimeInterval: self.delayTime, repeats: false) { _ in
            self.complete(false)
        }
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
        
        func loadModel() -> GESTURES31 {
            let config = MLModelConfiguration()
            guard let model = try? GESTURES31(configuration: config) else {
                fatalError("Failed to load the GESTURES31 model")
            }
            return model
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
        }
        
    }

