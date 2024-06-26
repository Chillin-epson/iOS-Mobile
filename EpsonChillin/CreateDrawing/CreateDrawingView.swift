//
//  CreateDrawingView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/20/24.
//
import UIKit
import SnapKit

class CreateDrawingView: BaseView {

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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "그림을 완성했어요!"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
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
    lazy var redrawingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "다시그리기 비활")
        button.setTitle("다시 그리기", for: .normal)
        button.setTitleColor(UIColor(named: "다시그리기 활성"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "다시그리기 활성")?.cgColor
        return button
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
    
    override func configureView() {
        addSubview(backgroundImageView)
        addSubview(a4PageImageView)
        addSubview(resultMediumImageView)
        addSubview(resultSmallImageView)
        addSubview(titleLabel)
        addSubview(resultImageView)
        addSubview(redrawingButton)
        addSubview(printButton)
        addSubview(sizeSelectLabel)
        addSubview(largeSizeButton)
        addSubview(mediumSizeButton)
        addSubview(smallSizeButton)
        addSubview(sizePrintButton)
        addSubview(loadingImageView)
        addSubview(progressBar)
        sendSubviewToBack(backgroundImageView)
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(0)
            make.height.equalTo(68)
            make.left.equalToSuperview().offset(20)
        }
        a4PageImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        resultImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        resultMediumImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(375)
        }
        resultSmallImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(80)
            make.height.equalTo(250)
        }
        redrawingButton.snp.makeConstraints { make in
            make.top.equalTo(resultImageView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(140)
            make.height.equalTo(60)
        }
        printButton.snp.makeConstraints { make in
            make.top.equalTo(resultImageView.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(redrawingButton.snp.right).offset(20)
            make.height.equalTo(60)
        }
        sizeSelectLabel.snp.makeConstraints { make in
            make.top.equalTo(resultImageView.snp.bottom).offset(15)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        let buttonWidth = (UIScreen.main.bounds.width - 60) / 3 // 3등분한 너비 계산
        
        largeSizeButton.snp.makeConstraints { make in
            make.top.equalTo(sizeSelectLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        mediumSizeButton.snp.makeConstraints { make in
            make.top.equalTo(sizeSelectLabel.snp.bottom).offset(10)
            make.left.equalTo(largeSizeButton.snp.right).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        smallSizeButton.snp.makeConstraints { make in
            make.top.equalTo(sizeSelectLabel.snp.bottom).offset(10)
            make.left.equalTo(mediumSizeButton.snp.right).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(40)
        }
        
        sizePrintButton.snp.makeConstraints { make in
            make.top.equalTo(largeSizeButton.snp.bottom).offset(20)
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
//                // 크기 조정 애니메이션
//                var height: CGFloat = 430
//                var width: CGFloat = 322.5
//                switch button {
//                case largeSizeButton:
//                    height = 430
//                    width = 322.5
//                case mediumSizeButton:
//                    height = 300
//                    width = 225
//                case smallSizeButton:
//                    height = 200
//                    width = 150
//                default:
//                    height = 430
//                    width = 322.5
//                }
//                
//                UIView.animate(withDuration: 0.3) {
//                    self.resultImageView.snp.remakeConstraints { make in
//                        make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
//                        make.left.equalToSuperview().inset(20)
//                        make.right.equalToSuperview().inset(20)
//                        make.height.equalTo(height)
//                        make.width.equalTo(width)
//                    }
//                    self.layoutIfNeeded()
//                }
//            } else {
//                button.backgroundColor = .white
//            }
//        }
//    }
    
    func printToggleLoading(_ isLoading: Bool) {
        titleLabel.isHidden = isLoading
        a4PageImageView.isHidden = isLoading
        resultImageView.isHidden = isLoading
        redrawingButton.isHidden = isLoading
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
        titleLabel.isHidden = isLoading
        titleLabel.isHidden = isLoading
        resultImageView.isHidden = isLoading
        redrawingButton.isHidden = isLoading
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

// UIImage 확장: 특정 색상과 크기의 이미지를 생성하기 위한 편의 메서드 추가
extension UIImage {
    convenience init?(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}








