////
////  test.swift
////  EpsonChillin
////
////  Created by 이승현 on 6/23/24.
////
//
//import UIKit
//import Vision
//import AVFoundation
//import Photos
//import SnapKit
//import Alamofire
//
//class MotionCheckViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    let motionCheckView = MotionCheckView()
//    var drawing: Drawing?
//    var motionSelected: String?
//    
//    override func loadView() {
//        self.view = motionCheckView
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = UIColor(named: "MainBackGroundColor")
//        
//        if let drawing = drawing, let url = URL(string: drawing.url) {
//            motionCheckView.resultImageView.kf.setImage(with: url)
//        }
//        if let drawing = drawing, let url = URL(string: drawing.url) {
//            motionCheckView.removeImageView.kf.setImage(with: url)
//        }
//        
//        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
//        backButton.tintColor = .gray
//        navigationItem.leftBarButtonItem = backButton
//        
//        configureView()
//    }
//    
//    @objc func closeButtonTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    override func configureView() {
//        motionCheckView.cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
//        motionCheckView.motionButton.addTarget(self, action: #selector(motionStartButtonTapped), for: .touchUpInside)
//        
//        motionCheckView.danceButton.addTarget(self, action: #selector(motionButtonTapped(_:)), for: .touchUpInside)
//        motionCheckView.helloButton.addTarget(self, action: #selector(motionButtonTapped(_:)), for: .touchUpInside)
//        motionCheckView.jumpButton.addTarget(self, action: #selector(motionButtonTapped(_:)), for: .touchUpInside)
//        motionCheckView.zombieButton.addTarget(self, action: #selector(motionButtonTapped(_:)), for: .touchUpInside)
//    }
//    // MARK: - 모션 선택 버튼
//    @objc func motionButtonTapped(_ sender: UIButton) {
//        let buttons = [motionCheckView.danceButton, motionCheckView.helloButton, motionCheckView.jumpButton, motionCheckView.zombieButton]
//        buttons.forEach { button in
//            if button == sender {
//                button.backgroundColor = .lightGray
//                switch button {
//                case motionCheckView.danceButton:
//                    motionSelected = "dance"
//                case motionCheckView.helloButton:
//                    motionSelected = "hello"
//                case motionCheckView.jumpButton:
//                    motionSelected = "jump"
//                case motionCheckView.zombieButton: motionSelected = "zombie"
//                default:
//                    break
//                }
//            } else {
//                button.backgroundColor = .white
//            }
//        }
//    }
//    // MARK: - 모션 생성 버튼
//    @objc func motionStartButtonTapped() {
//        guard let drawing = drawing else { return }
//        guard let motionSelected = motionSelected else {
//            print("No motion selected")
//            return
//        }
//        print("motionSelected: \(motionSelected)")
//        print("drawingId: \(drawing.drawingId)")
//        
//        motionCheckView.motionViewHidden(true)
//        startProgressBar {
//            let url = "https://api.zionhann.shop/app/chillin/motion/\(drawing.drawingId)"
//            let parameters: [String: Any] = [
//                "motionType": motionSelected
//            ]
//            let headers: HTTPHeaders = ["Content-Type": "application/json"]
//            
//            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    print("success: \(value)")
//                    
//                    if let json = value as? [String: Any], let gifUrlString = json["url"] as? String, let gifUrl = URL(string: gifUrlString) {
//                        self.presentMotionResultViewController(with: gifUrl)
//                    } else {
//                        print("Invalid response data")
//                        self.motionCheckView.motionViewHidden(false)
//                    }
//                case .failure(let error):
//                    print("Error: \(error)")
//                    self.motionCheckView.motionViewHidden(false)
//                }
//            }
//        }
//    }
//    
//    
//    
//    func presentMotionResultViewController(with gifUrl: URL) {
//        let motionResultVC = MotionResultViewController()
//        motionResultVC.gifUrl = gifUrl
//        
//        let motionResultNaviController = UINavigationController(rootViewController: motionResultVC)
//        motionResultNaviController.modalPresentationStyle = .overFullScreen
//        self.present(motionResultNaviController, animated: true, completion: nil)
//    }
//    
//    // MARK: - 카메라
//    @objc func cameraButtonTapped() {
//        presentCameraWithOverlay()
//    }
//    
//    func presentCameraWithOverlay() {
//        let cameraVC = UIImagePickerController()
//        cameraVC.delegate = self
//        cameraVC.sourceType = .camera
//        cameraVC.cameraOverlayView = createOverlayView()
//        present(cameraVC, animated: true, completion: nil)
//    }
//    
//    func createOverlayView() -> UIView {
//        let overlayView = UIView(frame: view.bounds)
//        overlayView.backgroundColor = .clear
//        overlayView.isUserInteractionEnabled = true
//        
//        let removeImageViewFrame = motionCheckView.convert(motionCheckView.removeImageView.frame, to: overlayView)
//        let removeImageView = UIImageView(frame: removeImageViewFrame)
//        removeImageView.image = motionCheckView.removeImageView.image
//        removeImageView.contentMode = .scaleAspectFit
//        removeImageView.isUserInteractionEnabled = true
//        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
//        removeImageView.addGestureRecognizer(panGesture)
//        removeImageView.addGestureRecognizer(pinchGesture)
//        
//        overlayView.addSubview(removeImageView)
//        
//        overlayView.isOpaque = false
//        overlayView.backgroundColor = UIColor.clear
//        
//        return overlayView
//    }
//    
//    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        guard let gestureView = gesture.view else { return }
//        let translation = gesture.translation(in: gestureView.superview)
//        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
//        gesture.setTranslation(.zero, in: gestureView.superview)
//    }
//    
//    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
//        guard let gestureView = gesture.view else { return }
//        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
//        gesture.scale = 1
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        if let originalImage = info[.originalImage] as? UIImage {
//            UIGraphicsBeginImageContextWithOptions(originalImage.size, false, originalImage.scale)
//            
//            originalImage.draw(in: CGRect(origin: .zero, size: originalImage.size))
//            
//            if let overlayImage = motionCheckView.removeImageView.image {
//                let overlayFrame = motionCheckView.removeImageView.frame
//                let imageSize = originalImage.size
//                let overlayOrigin = CGPoint(
//                    x: overlayFrame.origin.x * (imageSize.width / motionCheckView.bounds.width),
//                    y: overlayFrame.origin.y * (imageSize.height / motionCheckView.bounds.height)
//                )
//                let overlayAspect = overlayImage.size.width / overlayImage.size.height
//                let overlaySize: CGSize
//                if overlayFrame.size.width / overlayFrame.size.height > overlayAspect {
//                    overlaySize = CGSize(
//                        width: overlayFrame.size.height * overlayAspect * (imageSize.width / motionCheckView.bounds.width),
//                        height: overlayFrame.size.height * (imageSize.height / motionCheckView.bounds.height)
//                    )
//                } else {
//                    overlaySize = CGSize(
//                        width: overlayFrame.size.width * (imageSize.width / motionCheckView.bounds.width),
//                        height: overlayFrame.size.width / overlayAspect * (imageSize.height / motionCheckView.bounds.height)
//                    )
//                }
//                let overlayRect = CGRect(
//                    x: overlayOrigin.x + (overlayFrame.size.width * (imageSize.width / motionCheckView.bounds.width) - overlaySize.width) / 2,
//                    y: overlayOrigin.y + (overlayFrame.size.height * (imageSize.height / motionCheckView.bounds.height) - overlaySize.height) / 2,
//                    width: overlaySize.width,
//                    height: overlaySize.height
//                )
//                overlayImage.draw(in: overlayRect)
//            }
//            
//            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            
//            if let combinedImage = combinedImage {
//                UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
//            }
//        }
//        
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    func startProgressBar(completion: @escaping () -> Void) {
//        var progress: Float = 0.0
//        motionCheckView.setProgress(progress)
//        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
//            progress += 0.05
//            self.motionCheckView.setProgress(progress)
//            if progress >= 1.0 {
//                timer.invalidate()
//                completion()
//            }
//        }
//    }
//}
