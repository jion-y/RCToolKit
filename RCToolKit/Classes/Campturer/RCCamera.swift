//
//  RCCamera.swift
//  Pods
//
//  Created by yoyo on 2024/6/3.
//

import AVFoundation
import Foundation
public class RCCamera:NSObject {
    private var session: AVCaptureSession?
    private var curDevice: AVCaptureDevice?
    private var deviceInput: AVCaptureDeviceInput?
    private var captureOutputPhoto: AVCapturePhotoOutput?
    private var captureOutputVideo: AVCaptureVideoDataOutput?
    
    private let captureCaptureQueue = DispatchQueue(label: "com.rc.camera")
    public var supportPhotoModel: Bool = false
    
    public var postion: AVCaptureDevice.Position = .front {
        willSet {
            if self.postion != newValue {
                // 切换
            }
        }
    }

    public var preset: AVCaptureSession.Preset = .hd1280x720

    private var oldOrientation: AVCaptureVideoOrientation = .portrait
    public var orientation: AVCaptureVideoOrientation = .portrait 
//    {
//        didSet {
//            if self.oldOrientation != newValue {
//                self.setOrientationForConnection()
//            }
//            self.oldOrientation = newValue
//        }
//    }
    
    public func startCamera() {
        if self.session == nil {
            self.setupCamera()
            self.setupSession()
        }
        if !self.session!.isRunning {
            self.session?.startRunning()
        }
    }

    public func stopCamera() {
        if self.session!.isRunning {
            self.session?.stopRunning()
        }
    }
    public func takePhoto() {
        if self.supportPhotoModel {
//            self.captureOutputPhoto.
        }
    }
    private func setupCamera() {
        if self.session != nil {
            return
        }
        self.session = AVCaptureSession()
        
        self.session?.automaticallyConfiguresApplicationAudioSession = false
        self.curDevice = self.device(self.postion)
        guard let curDevice = self.curDevice else {
            return
        }
        do {
            try self.deviceInput = AVCaptureDeviceInput(device: curDevice)
            if self.supportPhotoModel {
                self.captureOutputPhoto = AVCapturePhotoOutput()
                self.captureOutputPhoto?.isHighResolutionCaptureEnabled = true
            }
            
            self.captureOutputVideo = AVCaptureVideoDataOutput()
            self.captureOutputVideo?.setSampleBufferDelegate(self, queue: self.captureCaptureQueue)
            
        } catch let error {
            print("\(error)")
        }
    }

    private func setupSession() {
        guard let session = self.session,let deviceInput = self.deviceInput,let curDev = self.curDevice  else {
            return
        }
        session.beginConfiguration()
        if self.curDevice?.position != self.postion {
            session.removeInput(deviceInput)
            do {
                try self.deviceInput = AVCaptureDeviceInput(device: curDev)
                if session.canAddInput(self.deviceInput!) {
                    session.addInput(self.deviceInput!)
                }
                session.removeOutput(self.captureOutputPhoto!)
                session.removeOutput(self.captureOutputVideo!)
                
                if self.supportPhotoModel {
                    if session.canAddOutput(self.captureOutputPhoto!) {
                        session.addOutput(self.captureOutputPhoto!)
                    }
                }
                if session.canAddOutput(self.captureOutputVideo!) {
                    session.addOutput(self.captureOutputVideo!)
                }
                
                self.setOrientationForConnection()
                
                var supportsFullRangeYUV = false
                var supportsVideoRangeYUV = false
                let supportedPixelFormats = self.captureOutputVideo!.__availableVideoCVPixelFormatTypes
                supportedPixelFormats.forEach { format in
                    if format.intValue == kCVPixelFormatType_420YpCbCr8PlanarFullRange {
                        supportsFullRangeYUV = true
                    }
                    if format.intValue == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange {
                        supportsVideoRangeYUV = true
                    }
                }
                if supportsFullRangeYUV {
                    self.captureOutputVideo?.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_420YpCbCr8PlanarFullRange]
                } else if supportsVideoRangeYUV {
                    self.captureOutputVideo?.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
                }
                
                if session.canSetSessionPreset(self.preset) {
                    session.sessionPreset = self.preset
                }
                
            } catch let error {
                print("\(error)")
            }
        }
        session.commitConfiguration()
    }
    
    private func device(_ postion: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = self.Devices()
        var device = devices.first
        devices.forEach { dev in
            if dev.position == postion {
                device = dev
            }
        }
        return device
    }
    
    public func setOrientationForConnection() {
        let connection = self.captureOutputVideo?.connection(with: .video)
        connection?.videoOrientation = self.orientation
    }

    public func Devices() -> [AVCaptureDevice] {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera]
        let diveceDisocoverSession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .unspecified)
        return diveceDisocoverSession.devices
    }
}

extension RCCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
}
