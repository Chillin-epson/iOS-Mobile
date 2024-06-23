//
//  CreateDrawingViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/20/24.
//

import UIKit
import Alamofire
import Kingfisher

class CreateDrawingViewController: BaseViewController {
    
    var createDrawingView = CreateDrawingView()
    var drawingId: Int?
    var selectedSize: String = "LARGE"
    
    override func loadView() {
        self.view = createDrawingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view?.backgroundColor = UIColor(named: "MainBackGroundColor")
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.tintColor = .gray
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func configureView() {
        createDrawingView.redrawingButton.addTarget(self, action: #selector(redrawingButtonTapped), for: .touchUpInside)
        createDrawingView.printButton.addTarget(self, action: #selector(printButtonTapped), for: .touchUpInside)
        createDrawingView.sizePrintButton.addTarget(self, action: #selector(sizePrintButtonTapped), for: .touchUpInside)
        
        createDrawingView.largeSizeButton.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        createDrawingView.mediumSizeButton.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        createDrawingView.smallSizeButton.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func redrawingButtonTapped() {
        let isActive = createDrawingView.redrawingButton.backgroundColor == UIColor(named: "다시그리기 비활")
        
        if isActive {
            createDrawingView.redrawingButton.backgroundColor = UIColor(named: "다시그리기 활성")
            createDrawingView.redrawingButton.setTitleColor(.white, for: .normal)
            createDrawingView.redrawingButton.layer.borderColor = UIColor(named: "다시그리기 비활")?.cgColor
        } else {
            createDrawingView.redrawingButton.backgroundColor = UIColor(named: "다시그리기 비활")
            createDrawingView.redrawingButton.setTitleColor(UIColor(named: "다시그리기 활성"), for: .normal)
            createDrawingView.redrawingButton.layer.borderColor = UIColor(named: "다시그리기 활성")?.cgColor
        }
        
        let voiceVC = VoiceViewController()
        self.navigationController?.pushViewController(voiceVC, animated: true)
        
    }
    
    @objc func printButtonTapped() {
        createDrawingView.redrawingButton.isHidden = true
        createDrawingView.printButton.isHidden = true
        createDrawingView.sizeSelectLabel.isHidden = false
        createDrawingView.largeSizeButton.isHidden = false
        createDrawingView.mediumSizeButton.isHidden = false
        createDrawingView.smallSizeButton.isHidden = false
        createDrawingView.sizePrintButton.isHidden = false
    }
    
    @objc func sizeButtonTapped(_ sender: UIButton) {
        let buttons = [createDrawingView.largeSizeButton, createDrawingView.mediumSizeButton, createDrawingView.smallSizeButton]
        buttons.forEach { button in
            if button == sender {
                button.backgroundColor = .lightGray
                switch button {
                case createDrawingView.largeSizeButton:
                    selectedSize = "LARGE"
                case createDrawingView.mediumSizeButton:
                    selectedSize = "MEDIUM"
                case createDrawingView.smallSizeButton:
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
            self.createDrawingView.printToggleLoading(true)
            self.startProgressBar()
            self.printDrawing()
            
            
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func printDrawing() {
        guard let drawingId = drawingId else { return }
        let parameters: [String: Any] = ["drawingId": drawingId, "scale": selectedSize]
        
        AF.request("https://api.zionhann.shop/app/chillin/drawings/print", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Print Success: \(value)")
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func loadImage(from url: URL) {
        createDrawingView.resultImageView.kf.setImage(with: url)
    }
    
    func startProgressBar() {
        var progress: Float = 0.0
        createDrawingView.setProgress(progress)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            progress += 0.2
            self.createDrawingView.setProgress(progress)
            if progress >= 1.0 {
                timer.invalidate()
                self.createDrawingView.printSuccessReturnUI(false)
                //얼럿창
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
        }
    }
}


