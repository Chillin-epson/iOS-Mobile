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

class MotionCheckViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let motionCheckView = MotionCheckView()
    var drawing: Drawing?
    var motionSelected: String? = "dance"
    
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
                        self.showAlert(message: "해당 그림은 움직이게 할 수 없습니다! 확인")
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
        overlayView.isUserInteractionEnabled = true
        
        let removeImageViewFrame = motionCheckView.convert(motionCheckView.removeImageView.frame, to: overlayView)
        let removeImageView = UIImageView(frame: removeImageViewFrame)
        removeImageView.image = motionCheckView.removeImageView.image
        removeImageView.contentMode = .scaleAspectFit
        removeImageView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        removeImageView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        removeImageView.addGestureRecognizer(pinchGesture)
        
        overlayView.addSubview(removeImageView)
        
        return overlayView
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: view.superview)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gesture.setTranslation(.zero, in: view.superview)
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }
    
    func captureScreen() -> UIImage? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                let rootView = window.rootViewController?.view
                let topMargin: CGFloat = 0
                let bottomMargin: CGFloat = 0
                let screenHeight = UIScreen.main.bounds.height
                let screenWidth = UIScreen.main.bounds.width
                let rect = CGRect(x: 0, y: topMargin, width: screenWidth, height: screenHeight - topMargin - bottomMargin)
                UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
                rootView?.drawHierarchy(in: rect, afterScreenUpdates: true)
                let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return capturedImage
            }
        }
        return nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 사진 찍은 후 오버레이된 이미지를 포함하여 스크린샷을 캡처
        if let capturedImage = captureScreen() {
            UIImageWriteToSavedPhotosAlbum(capturedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        // Dismiss the picker
        picker.dismiss(animated: true, completion: nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle error
            showAlert(message: "사진 저장에 실패했습니다: \(error.localizedDescription)")
        } else {
            // Handle success
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
}




