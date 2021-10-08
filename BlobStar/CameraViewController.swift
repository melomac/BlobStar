import UIKit
import SwiftUI

import AVFoundation
import CoreLocation
import Photos


class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    static let shared = CameraViewController()

    private var session = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var completionHandler: ((Bool, Error?) -> Void)? = nil
    private let locationManager = CLLocationManager()

    var location: CLLocation? {
        locationManager.location
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocation()
        setupSession()
        setupInput()
        setupOutput()
        setupPreview()
        start()
    }

    override func viewDidLayoutSubviews() {
        updatePreview()
    }

    override func viewWillDisappear(_ animated: Bool) {
        stop()
    }

    private func setupLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func setupSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                guard granted else {
                    fatalError("Session not authorized.")
                }
            })
        default:
            fatalError("Session not authorized.")
        }
        session.beginConfiguration()
        session.sessionPreset = .photo
        session.commitConfiguration()
    }

    private func setupInput() {
        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            fatalError("Setup input error.")
        }
        session.beginConfiguration()
        session.addInput(input)
        session.commitConfiguration()
    }

    private func setupOutput() {
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported

        guard session.canAddOutput(photoOutput) else {
            fatalError("Setup output error.")
        }
        session.beginConfiguration()
        session.addOutput(photoOutput)
        session.commitConfiguration()
    }

    private func setupPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
    }

    private func updatePreview() {
        previewLayer.videoGravity = .resize

        if let orientation = UIDevice.current.orientation.videoOrientation {
            previewLayer.connection?.videoOrientation = orientation
        }

        let bounds = view.layer.bounds
        previewLayer.bounds = bounds
        previewLayer.position = CGPoint.init(x: bounds.midX, y: bounds.midY)
        previewLayer.videoGravity = .resizeAspectFill
    }

    private func start() {
        if session.isRunning {
            return
        }
        session.startRunning()
    }

    private func stop() {
        if !session.isRunning {
            return
        }
        session.stopRunning()
    }

    public func takePhoto(flash flashMode: AVCaptureDevice.FlashMode = .auto, completionBlock: ((Bool, Error?) -> Void)? = nil) {
        // Orientation
        if let orientation = previewLayer.connection?.videoOrientation {
            if let photoOutputConnection = photoOutput.connection(with: .video) {
                photoOutputConnection.videoOrientation = orientation
            }
        }

        // Format
        let settings: AVCapturePhotoSettings
        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        } else {
            settings = AVCapturePhotoSettings()
        }

        // Flash mode
        if photoOutput.supportedFlashModes.contains(flashMode) {
            settings.flashMode = flashMode
        }

        completionHandler = completionBlock
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error capturing photo: \(error!.localizedDescription)")
            return
        }
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                return
            }
        }
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: photo.fileDataRepresentation()!, options: nil)
            creationRequest.location = self.location
        }, completionHandler: completionHandler)
    }
}


struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraViewController

    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController.shared
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
    }
}
