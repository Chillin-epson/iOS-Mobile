//
//  MotionCheckViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.

import UIKit
import Vision
import AVFoundation
import Photos
import SnapKit
import Alamofire

class MotionCheckViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let motionCheckView = MotionCheckView()
    var drawing: Drawing?
    var motionSelected: String? = "dance"
    var adjustedFrame: CGRect?

    override func loadView() {
        self.view = motionCheckView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "MainBackGroundColor")
        
        if let drawing = drawing, let url = URL(string: drawing.url) {
            motionCheckView.resultImageView.kf.setImage(with: url)
        }
        if let drawing = drawing, let url = URL(string: drawing.url) {
            motionCheckView.removeImageView.kf.setImage(with: url)
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
        motionCheckView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        motionCheckView.motionButton.addTarget(self, action: #selector(motionStartButtonTapped), for: .touchUpInside)
        
        motionCheckView.danceButton.addTarget(self, action: #selector(motionButtonTapped(_:)), for: .touchUpInside)
        motionCheckView.helloButton.addTarget(self, action: #selector(motionButtonTapped(_:)), for: .touchUpInside)
        motionCheckView.jumpButton.addTarget(self, action: #selector(motionButtonTapped(_:)), for: .touchUpInside)
        motionCheckView.zombieButton.addTarget(self, action: #selector(motionButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func motionButtonTapped(_ sender: UIButton) {
        let buttons = [motionCheckView.danceButton, motionCheckView.helloButton, motionCheckView.jumpButton, motionCheckView.zombieButton]
        buttons.forEach { button in
            if button == sender {
                button.backgroundColor = .lightGray
                switch button {
                case motionCheckView.danceButton:
                    motionSelected = "dance"
                case motionCheckView.helloButton:
                    motionSelected = "hello"
                case motionCheckView.jumpButton:
                    motionSelected = "jump"
                case motionCheckView.zombieButton:
                    motionSelected = "zombie"
                default:
                    break
                }
            } else {
                button.backgroundColor = .white
            }
        }
    }
    
    @objc func motionStartButtonTapped() {
        guard let drawing = drawing else { return }
        guard let motionSelected = motionSelected else {
            print("No motion selected")
            return
        }
        print("motionSelected: \(motionSelected)")
        print("drawingId: \(drawing.drawingId)")
        
        motionCheckView.motionViewHidden(true)
        startProgressBar {
            let url = "https://api.zionhann.shop/app/chillin/motion/\(drawing.drawingId)"
            let parameters: [String: Any] = [
                "motionType": motionSelected
            ]
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("value: \(value)")
                    if let json = value as? [String: Any], let gifUrlString = json["url"] as? String, let gifUrl = URL(string: gifUrlString) {
                        self.presentMotionResultViewController(with: gifUrl)
                        self.motionCheckView.motionViewHidden(false)
                    } else {
                        print("Invalid response data")
                        self.motionCheckView.motionViewHidden(false)
                        self.showAlert(message: "해당 그림은 움직이게 할 수 없습니다!")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    self.motionCheckView.motionViewHidden(false)
                    self.showAlert(message: "해당 그림은 움직이게 할 수 없습니다!")
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "확인", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentMotionResultViewController(with gifUrl: URL) {
        let motionResultVC = MotionResultViewController()
        motionResultVC.gifUrl = gifUrl
        
        let motionResultNaviController = UINavigationController(rootViewController: motionResultVC)
        motionResultNaviController.modalPresentationStyle = .overFullScreen
        self.present(motionResultNaviController, animated: true, completion: nil)
    }
    
    @objc func cameraButtonTapped() {
        presentCameraWithOverlay()
    }

    @objc func captureButtonTapped() {
        //takeSnapshotAndSave()
    }
    
    func presentCameraWithOverlay() {
        let cameraVC = UIImagePickerController()
        cameraVC.delegate = self
        cameraVC.sourceType = .camera
        cameraVC.cameraOverlayView = createOverlayView()
        
        // 기본 카메라 컨트롤 숨기기
        cameraVC.showsCameraControls = false
        
        // 카메라 미리보기 화면을 휴대폰 화면에 꽉 채우기
        let screenBounds = UIScreen.main.bounds
        let cameraAspectRatio: CGFloat = 4.0 / 3.0
        let cameraHeight = screenBounds.width * cameraAspectRatio
        let scale = screenBounds.height / cameraHeight
        cameraVC.cameraViewTransform = CGAffineTransform(translationX: 0, y: 80).scaledBy(x: scale, y: scale)
        
        present(cameraVC, animated: true, completion: nil)
    }
    
    func createOverlayView() -> UIView {
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = true
        
        let removeImageViewFrame = motionCheckView.convert(motionCheckView.removeImageView.frame, to: overlayView)
        let removeImageView = UIImageView(frame: removeImageViewFrame)
        removeImageView.image = motionCheckView.removeImageView.image
        removeImageView.contentMode = .scaleAspectFill  // 비율을 유지하지 않고 꽉 채움
        removeImageView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        removeImageView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchGesture.delegate = self
        removeImageView.addGestureRecognizer(pinchGesture)
        
        overlayView.addSubview(removeImageView)
        
        // 사용자 정의 셔터 버튼 추가
        let buttonHeight: CGFloat = 70
        let buttonMargin: CGFloat = 20
        
        let shutterButton = UIButton(frame: CGRect(x: (view.bounds.width - buttonHeight) / 2, y: view.bounds.height - buttonHeight - buttonMargin, width: buttonHeight, height: buttonHeight))
        shutterButton.backgroundColor = .red
        shutterButton.layer.cornerRadius = buttonHeight / 2
        shutterButton.addTarget(self, action: #selector(shutterButtonTapped), for: .touchUpInside)
        overlayView.addSubview(shutterButton)
        
        // 카메라 전환 버튼 추가 (오른쪽 하단)
        let switchCameraButton = UIButton(frame: CGRect(x: view.bounds.width - buttonHeight - buttonMargin, y: view.bounds.height - buttonHeight - buttonMargin, width: buttonHeight, height: buttonHeight))
        switchCameraButton.backgroundColor = .blue
        switchCameraButton.layer.cornerRadius = buttonHeight / 2
        switchCameraButton.setTitle("Flip", for: .normal)
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
        overlayView.addSubview(switchCameraButton)
        
        // 사용자 정의 취소 버튼 추가 (왼쪽 하단)
        let cancelButton = UIButton(frame: CGRect(x: buttonMargin, y: view.bounds.height - buttonHeight - buttonMargin, width: buttonHeight, height: buttonHeight))
        cancelButton.backgroundColor = .gray
        cancelButton.layer.cornerRadius = buttonHeight / 2
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        overlayView.addSubview(cancelButton)
        
        return overlayView
    }
    
    @objc func shutterButtonTapped() {
        // 셔터 버튼이 눌렸을 때 카메라로 사진 촬영
        if let imagePickerController = self.presentedViewController as? UIImagePickerController {
            imagePickerController.takePicture()
        }
    }

    @objc func switchCameraButtonTapped() {
        // 카메라 전환 버튼이 눌렸을 때 전면/후면 카메라 전환
        if let imagePickerController = self.presentedViewController as? UIImagePickerController {
            imagePickerController.cameraDevice = (imagePickerController.cameraDevice == .rear) ? .front : .rear
        }
    }
    
    @objc func cancelButtonTapped() {
        // 취소 버튼이 눌렸을 때 카메라 닫기
        if let imagePickerController = self.presentedViewController as? UIImagePickerController {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view.superview)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: view.superview)
        adjustedFrame = view.frame
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
        adjustedFrame = view.frame
    }
    
    // UIGestureRecognizerDelegate 메서드 추가
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(message: "사진 저장에 실패했습니다: \(error.localizedDescription)")
        } else {
            showAlert(message: "사진이 성공적으로 저장되었습니다.")
        }
    }
    
    func startProgressBar(completion: @escaping () -> Void) {
        var progress: Float = 0.0
        motionCheckView.setProgress(progress)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            progress += 0.05
            self.motionCheckView.setProgress(progress)
            if progress >= 3.0 {
                timer.invalidate()
                completion()
            }
        }
    }
    
    // 새로운 메서드 추가
    func takeSnapshotWithOverlayAndSave(capturedImage: UIImage) {
        UIGraphicsBeginImageContextWithOptions(capturedImage.size, false, capturedImage.scale)
        
        capturedImage.draw(in: CGRect(origin: .zero, size: capturedImage.size))
        
        if let overlayImage = motionCheckView.removeImageView.image, let adjustedFrame = adjustedFrame {
            let overlaySize = adjustedFrame.size
            let overlayOrigin = adjustedFrame.origin
            let imageSize = capturedImage.size
            let overlayRect = CGRect(
                origin: CGPoint(x: overlayOrigin.x * (imageSize.width / view.bounds.width),
                                y: overlayOrigin.y * (imageSize.height / view.bounds.height)),
                size: CGSize(width: overlaySize.width * (imageSize.width / view.bounds.width),
                             height: overlaySize.height * (imageSize.height / view.bounds.height))
            )
            overlayImage.draw(in: overlayRect, blendMode: .normal, alpha: 1.0)
        }
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let combinedImage = combinedImage {
            UIImageWriteToSavedPhotosAlbum(combinedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    // UIImagePickerControllerDelegate 메서드 수정
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            takeSnapshotWithOverlayAndSave(capturedImage: originalImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// UIView의 snapshotImage 확장 메서드 추가
extension UIView {
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}















