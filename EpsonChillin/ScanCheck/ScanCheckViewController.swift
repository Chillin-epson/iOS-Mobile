//
//  ScanCheckViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.

import UIKit
import Vision
import AVFoundation
import Photos
import SnapKit

class ScanCheckViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let scanCheckView = ScanCheckView()
    var drawing: Drawing?
    
    override func loadView() {
        self.view = scanCheckView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "MainBackGroundColor")
        
        if let drawing = drawing, let url = URL(string: drawing.url) {
            scanCheckView.resultImageView.kf.setImage(with: url)
            scanCheckView.removeImageView.kf.setImage(with: url)
        }
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.tintColor = .gray
        navigationItem.leftBarButtonItem = backButton
        
        configureView()
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func configureView() {
        scanCheckView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    @objc func cameraButtonTapped() {
        presentCameraWithOverlay()
    }
    
    func presentCameraWithOverlay() {
        let cameraVC = UIImagePickerController()
        cameraVC.delegate = self
        cameraVC.sourceType = .camera
        cameraVC.cameraOverlayView = createOverlayView()
        present(cameraVC, animated: true, completion: nil)
    }
    
    func createOverlayView() -> UIView {
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false // 터치 이벤트 전달을 위해 추가
        
        // ScanCheckView의 removeImageView 위치를 기준으로 카메라 오버레이 뷰에 이미지 뷰 추가
        let removeImageViewFrame = scanCheckView.convert(scanCheckView.removeImageView.frame, to: overlayView)
        let removeImageView = UIImageView(frame: removeImageViewFrame)
        removeImageView.image = scanCheckView.removeImageView.image
        removeImageView.contentMode = .scaleAspectFit
        
        overlayView.addSubview(removeImageView)
        
        return overlayView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            UIGraphicsBeginImageContextWithOptions(originalImage.size, false, originalImage.scale)
            
            originalImage.draw(in: CGRect(origin: .zero, size: originalImage.size))
            
            if let overlayImage = scanCheckView.removeImageView.image {
                // removeImageView의 크기와 위치를 실제 캡처 이미지의 크기에 맞게 변환하여 비율 유지
                let overlayFrame = scanCheckView.removeImageView.frame
                let imageSize = originalImage.size
                let overlayOrigin = CGPoint(
                    x: overlayFrame.origin.x * (imageSize.width / scanCheckView.bounds.width),
                    y: overlayFrame.origin.y * (imageSize.height / scanCheckView.bounds.height)
                )
                let overlayAspect = overlayImage.size.width / overlayImage.size.height
                let overlaySize: CGSize
                if overlayFrame.size.width / overlayFrame.size.height > overlayAspect {
                    overlaySize = CGSize(
                        width: overlayFrame.size.height * overlayAspect * (imageSize.width / scanCheckView.bounds.width),
                        height: overlayFrame.size.height * (imageSize.height / scanCheckView.bounds.height)
                    )
                } else {
                    overlaySize = CGSize(
                        width: overlayFrame.size.width * (imageSize.width / scanCheckView.bounds.width),
                        height: overlayFrame.size.width / overlayAspect * (imageSize.height / scanCheckView.bounds.height)
                    )
                }
                let overlayRect = CGRect(
                    x: overlayOrigin.x + (overlayFrame.size.width * (imageSize.width / scanCheckView.bounds.width) - overlaySize.width) / 2,
                    y: overlayOrigin.y + (overlayFrame.size.height * (imageSize.height / scanCheckView.bounds.height) - overlaySize.height) / 2,
                    width: overlaySize.width,
                    height: overlaySize.height
                )
                overlayImage.draw(in: overlayRect)
            }
            
            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let combinedImage = combinedImage {
                UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}














