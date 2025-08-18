//
//  CameraQR.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 18/8/25.
//
import Foundation
import AVFoundation
import SwiftUI
///////////////////
struct BarcodeScannerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: BarcodeScannerViewModel
    var onScanned: (String) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .black

        // Setup camera preview
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = viewController.view.bounds
        viewController.view.layer.addSublayer(previewLayer)

        // Start scanning with preview layer
        viewModel.startScanning(previewLayer: previewLayer) { scannedCode in
            onScanned(scannedCode)
        }
        
        // Add custom overlay for scan area
        let scanFrame = CGRect(x: viewController.view.bounds.midX - 150, y: viewController.view.bounds.midY - 50, width: 300, height: 100)
        let overlayView = UIView(frame: scanFrame)
        overlayView.layer.borderColor = UIColor.red.cgColor
        overlayView.layer.borderWidth = 2.0
        overlayView.backgroundColor = UIColor.clear
        viewController.view.addSubview(overlayView)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update any changes when the view needs to be updated
    }
}

class BarcodeScannerViewModel: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    var onScanned: ((String) -> Void)?

    func startScanning(previewLayer: AVCaptureVideoPreviewLayer, onScanned: @escaping (String) -> Void) {
        self.onScanned = onScanned
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Unable to initialize video input: \(error)")
            return
        }

        if let captureSession = captureSession, captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if let captureSession = captureSession, captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13, .ean8, .qr, .code128, .code39]
            metadataOutput.rectOfInterest = previewLayer.bounds
        }

        self.previewLayer = previewLayer
        self.previewLayer?.session = captureSession

        captureSession?.startRunning()
    }

    func stopScanning() {
        captureSession?.stopRunning()
        captureSession = nil
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue else {
            return
        }
        
        // Vibrate on successful scan
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // Notify with the scanned value and stop scanning
        DispatchQueue.main.async { [weak self] in
            self?.scannedCode = stringValue
            self?.onScanned?(stringValue)
            self?.stopScanning()
        }
    }
}
