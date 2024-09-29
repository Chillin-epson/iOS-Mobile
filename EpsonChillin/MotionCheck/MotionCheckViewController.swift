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
        
        if let drawing = drawing, let url = URL(string: drawing.url) {
            motionCheckView.resultImageView.kf.setImage(with: url)
        }
//        if let drawing = drawing, let url = URL(string: drawing.url) {
//            motionCheckView.removeImageView.kf.setImage(with: url)
//        }
        //이미지의 크기를 움직이지 않아도 기본값 크기에 맞는 이미지를 올림
        if let drawing = drawing, let url = URL(string: drawing.url) {
                    motionCheckView.removeImageView.kf.setImage(with: url, completionHandler: { result in
                        switch result {
                        case .success(let value):
                            DispatchQueue.main.async {
                                self.adjustedFrame = self.motionCheckView.removeImageView.frame
                                self.motionCheckView.removeImageView.image = value.image
                            }
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    })
                }
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.tintColor = .gray
        navigationItem.leftBarButtonItem = backButton
        
        configureView()
        //캐릭터를 움직이지 않으면 기본값으로 원래크기를 넣음
        adjustedFrame = motionCheckView.removeImageView.frame
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
        startProgressBar()
            let url = "https://api.zionhann.com/chillin/motion/\(drawing.drawingId)"
            let parameters: [String: Any] = [
                "motionType": motionSelected
            ]
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
            print("888888")
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("value999: \(value)")
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
        
        // 카메라 미리보기 화면을 정사각형으로 설정
        let screenBounds = UIScreen.main.bounds
        let squareLength = screenBounds.width // 가로 너비를 기준으로 정사각형 생성
        let yOffset = (screenBounds.height - squareLength) / 2
        
        // 정사각형 비율 유지 및 화면 중앙에 위치
        let scale = squareLength / screenBounds.width
        cameraVC.cameraViewTransform = CGAffineTransform(translationX: 0, y: 140).scaledBy(x: scale, y: scale)
        
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
        
        let shutterButton = UIButton(frame: CGRect(x: (view.bounds.width - buttonHeight) / 2, y: (view.bounds.height - buttonHeight - buttonMargin - 70), width: buttonHeight, height: buttonHeight))
        shutterButton.backgroundColor = .white
        shutterButton.tintColor = .black
        shutterButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        shutterButton.layer.cornerRadius = buttonHeight / 2
        shutterButton.addTarget(self, action: #selector(shutterButtonTapped), for: .touchUpInside)
        overlayView.addSubview(shutterButton)
        
        // 카메라 전환 버튼 추가 (오른쪽 하단)
        let switchCameraButton = UIButton(frame: CGRect(x: view.bounds.width - buttonHeight - buttonMargin, y: (view.bounds.height - buttonHeight - buttonMargin - 70), width: buttonHeight, height: buttonHeight))
        switchCameraButton.backgroundColor = .darkGray
        switchCameraButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        switchCameraButton.tintColor = .white
        switchCameraButton.imageView?.contentMode = .scaleAspectFill
        switchCameraButton.layer.cornerRadius = buttonHeight / 2
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
        overlayView.addSubview(switchCameraButton)
        
        // 사용자 정의 취소 버튼 추가 (왼쪽 하단)
        let cancelButton = UIButton(frame: CGRect(x: buttonMargin, y: (view.bounds.height - buttonHeight - buttonMargin - 70), width: buttonHeight, height: buttonHeight))
        cancelButton.backgroundColor = .darkGray
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.layer.cornerRadius = buttonHeight / 2
        cancelButton.tintColor = .white
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
    
    func startProgressBar() {
        var progress: Float = 0.0
        motionCheckView.setProgress(progress)
        let duration: Float = 60.0
        let increment = 1.0 / duration

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            progress += increment
            self.motionCheckView.setProgress(progress)
            if progress >= 1.0 {
                timer.invalidate()
                self.motionCheckView.motionViewHidden(false)
            }
        }
    }

    // 새로운 메서드 수정
    func takeSnapshotWithOverlayAndSave(capturedImage: UIImage, isFrontCamera: Bool) {
        var imageToSave = capturedImage
        if isFrontCamera {
            // 좌우 대칭하여 이미지를 저장
            imageToSave = UIImage(cgImage: capturedImage.cgImage!, scale: capturedImage.scale, orientation: .leftMirrored)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageToSave.size, false, imageToSave.scale)
        
        imageToSave.draw(in: CGRect(origin: .zero, size: imageToSave.size))
        
        if let overlayImage = motionCheckView.removeImageView.image, let adjustedFrame = adjustedFrame {
            let overlaySize = adjustedFrame.size
            let overlayOrigin = adjustedFrame.origin
            let imageSize = imageToSave.size
            
            let adjustedOverlayRect = CGRect(
                origin: CGPoint(x: overlayOrigin.x * (imageSize.width / view.bounds.width),
                                y: overlayOrigin.y * (imageSize.height / view.bounds.height)),
                size: CGSize(width: overlaySize.width * (imageSize.width / view.bounds.width),
                             height: overlaySize.height * (imageSize.height / view.bounds.height))
            )
            //비율
            let aspectRatio = overlayImage.size.width / overlayImage.size.height
            var finalOverlayRect = adjustedOverlayRect
            
            if aspectRatio > 1 {
                finalOverlayRect.size.height = finalOverlayRect.size.width / aspectRatio
            } else {
                finalOverlayRect.size.width = finalOverlayRect.size.height * aspectRatio
            }
            //크기 작아진걸 배율키움
            finalOverlayRect.size.width *= 1.7
            finalOverlayRect.size.height *= 1.7
            finalOverlayRect.origin.x -= (finalOverlayRect.size.width - adjustedOverlayRect.size.width) / 2
            finalOverlayRect.origin.y -= (finalOverlayRect.size.height - adjustedOverlayRect.size.height) / 2
            
            overlayImage.draw(in: finalOverlayRect, blendMode: .normal, alpha: 1.0)
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
            let isFrontCamera = picker.cameraDevice == .front
            takeSnapshotWithOverlayAndSave(capturedImage: originalImage, isFrontCamera: isFrontCamera)
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
