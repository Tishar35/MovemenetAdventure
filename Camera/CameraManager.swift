
import AVFoundation
import SwiftUI
import UIKit

final class CameraManager: NSObject, ObservableObject {

    @Published private(set) var permissionGranted = false
    @Published private(set) var isRunning = false
    @Published var errorMessage: String?

    let session = AVCaptureSession()

    private let queue = DispatchQueue(label: "movementAdventure.camera")

    func requestPermissionAndStart() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {

        case .authorized:
            configureAndStart()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.permissionGranted = granted

                    if granted {
                        self?.configureAndStart()
                    } else {
                        self?.errorMessage = "Camera access is needed for camera play. You can still explore DEMO MODE."
                    }
                }
            }

        default:
            DispatchQueue.main.async {
                self.permissionGranted = false
                self.errorMessage = "Camera permission is unavailable. Enable it in Settings or choose DEMO MODE."
            }
        }
    }

    private func configureAndStart() {
        queue.async {
            guard !self.session.isRunning else { return }

            self.session.beginConfiguration()
            self.session.sessionPreset = .high

            guard
                let device = AVCaptureDevice.default(
                    .builtInWideAngleCamera,
                    for: .video,
                    position: .front
                ),
                let input = try? AVCaptureDeviceInput(device: device),
                self.session.canAddInput(input)
            else {
                self.session.commitConfiguration()

                DispatchQueue.main.async {
                    self.errorMessage = "No compatible camera was found."
                }
                return
            }

            if self.session.inputs.isEmpty {
                self.session.addInput(input)
            }

            self.session.commitConfiguration()
            self.session.startRunning()

            DispatchQueue.main.async {
                self.permissionGranted = true
                self.isRunning = true
            }
        }
    }

    func stop() {
        queue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }

            DispatchQueue.main.async {
                self.isRunning = false
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
    }
}

final class PreviewView: UIView {

    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}
