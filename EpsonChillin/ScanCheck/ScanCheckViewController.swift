//
//  ScanCheckViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.

import UIKit
import Alamofire
import Kingfisher
import Photos

class ScanCheckViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let scanCheckView = ScanCheckView()
    var drawingId: Int?
    var selectedSize: String = "LARGE"
    var drawing: Drawing?
    
    override func loadView() {
        self.view = scanCheckView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let drawing = drawing, let url = URL(string: drawing.url) {
            scanCheckView.resultImageView.kf.setImage(with: url)
            scanCheckView.removeImageView.kf.setImage(with: url)
            scanCheckView.resultMediumImageView.kf.setImage(with: url)
            scanCheckView.resultSmallImageView.kf.setImage(with: url)
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
        scanCheckView.printButton.addTarget(self, action: #selector(printButtonTapped), for: .touchUpInside)
        scanCheckView.sizePrintButton.addTarget(self, action: #selector(sizePrintButtonTapped), for: .touchUpInside)
        //버튼색 바꾸기
        scanCheckView.largeSizeButton.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        scanCheckView.mediumSizeButton.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        scanCheckView.smallSizeButton.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        //사이즈별 미리보기화면
        scanCheckView.largeSizeButton.addTarget(self, action: #selector(largeSizeButtonTapped), for: .touchUpInside)
        scanCheckView.mediumSizeButton.addTarget(self, action: #selector(mediumSizeButtonTapped), for: .touchUpInside)
        scanCheckView.smallSizeButton.addTarget(self, action: #selector(smallSizeButtonTapped), for: .touchUpInside)
        scanCheckView.saveImageButton.addTarget(self, action: #selector(saveImageButtonTapped), for: .touchUpInside)
    }
    
    @objc func printButtonTapped() {
        scanCheckView.printButton.isHidden = true
        scanCheckView.sizeSelectLabel.isHidden = false
        scanCheckView.largeSizeButton.isHidden = false
        scanCheckView.mediumSizeButton.isHidden = false
        scanCheckView.smallSizeButton.isHidden = false
        scanCheckView.sizePrintButton.isHidden = false
        scanCheckView.saveImageButton.isHidden = true
    }
    
    @objc func largeSizeButtonTapped() {
        scanCheckView.resultImageView.isHidden = false
        scanCheckView.resultMediumImageView.isHidden = true
        scanCheckView.resultSmallImageView.isHidden = true
    }
    
    @objc func mediumSizeButtonTapped() {
        scanCheckView.resultImageView.isHidden = true
        scanCheckView.resultMediumImageView.isHidden = false
        scanCheckView.resultSmallImageView.isHidden = true
    }
    
    @objc func smallSizeButtonTapped() {
        scanCheckView.resultImageView.isHidden = true
        scanCheckView.resultMediumImageView.isHidden = true
        scanCheckView.resultSmallImageView.isHidden = false
    }
    
    @objc func sizeButtonTapped(_ sender: UIButton) {
        let buttons = [scanCheckView.largeSizeButton, scanCheckView.mediumSizeButton, scanCheckView.smallSizeButton]
        buttons.forEach { button in
            if button == sender {
                button.backgroundColor = .lightGray
                switch button {
                case scanCheckView.largeSizeButton:
                    selectedSize = "LARGE"
                case scanCheckView.mediumSizeButton:
                    selectedSize = "MEDIUM"
                case scanCheckView.smallSizeButton:
                    selectedSize = "SMALL"
                default:
                    selectedSize = "LARGE"
                }
            } else {
                button.backgroundColor = .white
            }
        }
    }
    
    @objc func sizePrintButtonTapped() {
        let alertController = UIAlertController(title: "인쇄 확인", message: "정말로 인쇄하시겠습니까?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "예", style: .default) { _ in
            self.scanCheckView.printToggleLoading(true)
            self.printDrawing()
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
            self.showPrintAndSaveButtons()
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showPrintAndSaveButtons() {
        scanCheckView.sizeSelectLabel.isHidden = true
        scanCheckView.largeSizeButton.isHidden = true
        scanCheckView.mediumSizeButton.isHidden = true
        scanCheckView.smallSizeButton.isHidden = true
        scanCheckView.sizePrintButton.isHidden = true
        scanCheckView.printButton.isHidden = false
        scanCheckView.saveImageButton.isHidden = false
    }
    
    func printDrawing() {
        guard let drawingId = drawingId else { return }
        print("drawingId: \(drawingId)")
        let parameters: [String: Any] = ["drawingId": drawingId, "scale": selectedSize]
        
        AF.request("https://api.zionhann.com/chillin/drawings/print", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                if statusCode == 200 {
                    print("Print Success: \(response)")
                    self.showPrintSuccessAlert()
                } else {
                    print("Print Failure: \(response)")
                    self.showPrintFailureAlert()
                }
            } else {
                print("Error: \(response.error ?? AFError.explicitlyCancelled)")
                self.showPrintFailureAlert()
            }
            self.scanCheckView.printSuccessReturnUI(false)
        }
    }
    
    @objc func saveImageButtonTapped() {
        guard let image = scanCheckView.resultImageView.image else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                print("Authorization denied")
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully")
            let alert = UIAlertController(title: "저장 완료", message: "이미지가 갤러리에 저장되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showPrintSuccessAlert() {
        let alertController = UIAlertController(title: "프린트 완료!", message: "처음화면으로 돌아가시겠습니까?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "예", style: .default) { _ in
            let mainVC = MainViewController()
            let mainNaviController = UINavigationController(rootViewController: mainVC)
            mainNaviController.modalPresentationStyle = .overFullScreen
            self.present(mainNaviController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func showPrintFailureAlert() {
        let alertController = UIAlertController(title: "오류!", message: "프린트 실패!", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.showPrintAndSaveButtons()
        }
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func startProgressBar() {
        var progress: Float = 0.0
        scanCheckView.setProgress(progress)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            progress += 0.2
            self.scanCheckView.setProgress(progress)
            if progress >= 1.0 {
                timer.invalidate()
            }
        }
    }
}







