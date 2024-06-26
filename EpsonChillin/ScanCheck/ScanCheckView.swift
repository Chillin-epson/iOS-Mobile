//
//  ScanCheckView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

//import UIKit
//import SnapKit
//
//class ScanCheckView: BaseView {
//    
//    lazy var backgroundImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "배경")
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//    
//    lazy var resultImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 16
//        imageView.layer.masksToBounds = true
//        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
//        return imageView
//    }()
//    
//    lazy var cameraButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 10
//        button.backgroundColor = .lightGray
//        let cameraImage = UIImage(systemName: "camera.fill")
//        button.setImage(cameraImage, for: .normal)
//        button.backgroundColor = .white
//        button.tintColor = .black
//        button.imageView?.contentMode = .scaleAspectFit
//        return button
//    }()
//    
//    lazy var printButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 10
//        button.backgroundColor = UIColor(named: "인쇄하기 비활")
//        button.setTitle("인쇄하기", for: .normal)
//        button.setTitleColor(UIColor(named: "인쇄하기 활성"), for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor(named: "인쇄하기 활성")?.cgColor
//        return button
//    }()
//    
//    lazy var removeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 16
//        imageView.layer.masksToBounds = true
//        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
//        imageView.isHidden = true
//        return imageView
//    }()
//    
//    override func configureView() {
//        addSubview(backgroundImageView)
//        addSubview(resultImageView)
//        addSubview(cameraButton)
//        addSubview(printButton)
//        addSubview(removeImageView)
//        sendSubviewToBack(backgroundImageView)
//    }
//    
//    override func setConstraints() {
//        backgroundImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        resultImageView.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
//            make.left.right.equalToSuperview().inset(20)
//            make.height.equalTo(500)
//        }
//        cameraButton.snp.makeConstraints { make in
//            make.top.equalTo(resultImageView.snp.bottom).offset(20)
//            make.trailing.equalToSuperview().inset(20)
//            make.width.height.equalTo(60)
//        }
//        
////        removeImageView.snp.makeConstraints { make in
////            make.top.equalTo(resultImageView.snp.bottom).offset(0)
////            make.leading.equalToSuperview().inset(20)
////            make.width.height.equalTo(100)
////        }
//        
//        removeImageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalToSuperview().inset(10)
//            make.width.height.equalTo(200)
//        }
//    }
//}

import UIKit
import SnapKit

class ScanCheckView: BaseView {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "배경")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var a4PageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        imageView.isHidden = false
        return imageView
    }()
    
    lazy var resultMediumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var resultSmallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var printButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "인쇄하기 비활")
        button.setTitle("인쇄하기", for: .normal)
        button.setTitleColor(UIColor(named: "인쇄하기 활성"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "인쇄하기 활성")?.cgColor
        return button
    }()
    
    lazy var sizeSelectLabel: UILabel = {
        let label = UILabel()
        label.text = "크기 선택하기"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    lazy var largeSizeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("크게", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.isHidden = true
        //button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var mediumSizeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("중간", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.isHidden = true
        //button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var smallSizeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("작게", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.isHidden = true
        //button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var sizePrintButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "인쇄하기 비활")
        button.setTitle("인쇄하기", for: .normal)
        button.setTitleColor(UIColor(named: "인쇄하기 활성"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "인쇄하기 활성")?.cgColor
        button.isHidden = true
        return button
    }()
    
    lazy var loadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "프린트로딩")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(named: "printProgressBar")
        progressView.trackTintColor = .lightGray
        progressView.isHidden = true
        return progressView
    }()
    
    lazy var removeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        imageView.isHidden = true
        return imageView
    }()
    lazy var saveImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "1")
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(named: "2")?.cgColor
        return button
    }()
    
    override func configureView() {
        addSubview(a4PageImageView)
        addSubview(backgroundImageView)
        addSubview(resultImageView)
        addSubview(resultMediumImageView)
        addSubview(resultSmallImageView)
        addSubview(printButton)
        addSubview(sizeSelectLabel)
        addSubview(largeSizeButton)
        addSubview(mediumSizeButton)
        addSubview(smallSizeButton)
        addSubview(sizePrintButton)
        addSubview(loadingImageView)
        addSubview(progressBar)
        addSubview(removeImageView)
        addSubview(saveImageButton)
        sendSubviewToBack(backgroundImageView)
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        a4PageImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        resultImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        resultMediumImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(375)
        }
        resultSmallImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(80)
            make.height.equalTo(250)
        }
        printButton.snp.makeConstraints { make in
            make.top.equalTo(resultImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        sizeSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(resultImageView.snp.bottom).offset(25)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        let buttonWidth = (UIScreen.main.bounds.width - 60) / 3
        
        largeSizeButton.snp.makeConstraints { make in
            make.top.equalTo(sizeSelectLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        mediumSizeButton.snp.makeConstraints { make in
            make.top.equalTo(sizeSelectLabel.snp.bottom).offset(20)
            make.left.equalTo(largeSizeButton.snp.right).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        smallSizeButton.snp.makeConstraints { make in
            make.top.equalTo(sizeSelectLabel.snp.bottom).offset(20)
            make.left.equalTo(mediumSizeButton.snp.right).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        sizePrintButton.snp.makeConstraints { make in
            make.top.equalTo(largeSizeButton.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        saveImageButton.snp.makeConstraints { make in
            make.top.equalTo(printButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        loadingImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(390)
            make.left.right.equalToSuperview().inset(20)
        }
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(loadingImageView.snp.bottom).offset(90)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }
    }
    
//    @objc func sizeButtonTapped(_ sender: UIButton) {
//        let buttons = [largeSizeButton, mediumSizeButton, smallSizeButton]
//        buttons.forEach { button in
//            if button == sender {
//                button.backgroundColor = .lightGray
//
//                var height: CGFloat = 500
//                switch button {
//                case largeSizeButton:
//                    height = 500
//                case mediumSizeButton:
//                    height = 375
//                case smallSizeButton:
//                    height = 250
//                default:
//                    height = 500
//                }
//
//                UIView.animate(withDuration: 0.3) {
//                    self.resultImageView.snp.updateConstraints { make in
//                        make.height.equalTo(height)
//                    }
//                    self.layoutIfNeeded()
//                }
//            } else {
//                button.backgroundColor = .white
//            }
//        }
//    }
    
    func printToggleLoading(_ isLoading: Bool) {
        resultImageView.isHidden = isLoading
        printButton.isHidden = isLoading
        sizeSelectLabel.isHidden = isLoading
        largeSizeButton.isHidden = isLoading
        mediumSizeButton.isHidden = isLoading
        smallSizeButton.isHidden = isLoading
        sizePrintButton.isHidden = isLoading
        loadingImageView.isHidden = !isLoading
        progressBar.isHidden = !isLoading
    }
    
    func setProgress(_ progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
    
    func printSuccessReturnUI(_ isLoading: Bool) {
        resultImageView.isHidden = isLoading
        printButton.isHidden = isLoading
        sizeSelectLabel.isHidden = !isLoading
        largeSizeButton.isHidden = !isLoading
        mediumSizeButton.isHidden = !isLoading
        smallSizeButton.isHidden = !isLoading
        sizePrintButton.isHidden = !isLoading
        loadingImageView.isHidden = !isLoading
        progressBar.isHidden = !isLoading
    }
}
