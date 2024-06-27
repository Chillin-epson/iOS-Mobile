//
//  Voiceview.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/15/24.
//

import Foundation
import UIKit
import SnapKit
import Lottie

class VoiceView: BaseView, UITextViewDelegate {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "배경")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let placeholderText = "색칠하고 싶은 그림을 \n말로 표현해보세요!"
    
    lazy var voiceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "색칠하고 싶은 그림을 설명해주세요!"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    lazy var voiceSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "자세히 설명할수록 원하는 그림을 얻을 수 있어요"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 30)
        textView.textColor = UIColor.lightGray
        textView.isEditable = true
        textView.backgroundColor = .white
        textView.attributedText = placeholderAttributedText()
        textView.layer.cornerRadius = 15
        textView.textContainerInset = UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
        textView.delegate = self
        return textView
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(named: "recordButton") {
            button.setImage(image, for: .normal)
        } else {
            print("녹음 image not found")
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("", for: .normal)
        button.setTitle("", for: .highlighted)
        button.setTitle("", for: .selected)
        return button
    }()
    
    lazy var drawingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("도안 만들기", for: .normal)
        button.setTitleColor(UIColor(named: "인쇄하기 활성"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .white
        //button.backgroundColor = UIColor(named: "인쇄하기 비활")
        //button.layer.borderColor = UIColor(named: "인쇄하기 활성")?.cgColor

        return button
    }()
    
    lazy var loadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "그림로딩")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(named: "progressBar")
        progressView.trackTintColor = .lightGray
        progressView.isHidden = true
        return progressView
    }()
    
    override func configureView() {
        addSubview(backgroundImageView)
        addSubview(voiceTitleLabel)
        addSubview(voiceSubTitleLabel)
        addSubview(textView)
        addSubview(recordButton)
        addSubview(drawingButton)
        addSubview(loadingImageView)
        addSubview(progressBar)
        
        sendSubviewToBack(backgroundImageView)
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(-10)
            make.right.equalToSuperview().inset(-10)
            make.bottom.equalToSuperview().inset(-10)
        }
        voiceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        voiceSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(voiceTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        drawingButton.snp.makeConstraints { make in
            make.top.equalTo(voiceSubTitleLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(drawingButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(recordButton.snp.top).offset(-20)
        }
        recordButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        if let imageView = recordButton.imageView {
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(90)
            }
        }
        
        loadingImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(390)
            make.left.right.equalToSuperview().inset(20)
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(loadingImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }
    }
    
    func placeholderAttributedText() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10 // 행간 간격 설정
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30),
            .foregroundColor: UIColor.lightGray,
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: placeholderText, attributes: attributes)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.attributedText = placeholderAttributedText()
        }
    }
    
    func removePlaceholder() {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func setPlaceholder() {
        if textView.text.isEmpty {
            textView.attributedText = placeholderAttributedText()
        }
    }
    
    func toggleLoading(_ isLoading: Bool) {
        voiceTitleLabel.isHidden = isLoading
        voiceSubTitleLabel.isHidden = isLoading
        textView.isHidden = isLoading
        recordButton.isHidden = isLoading
        drawingButton.isHidden = isLoading
        loadingImageView.isHidden = !isLoading
        progressBar.isHidden = !isLoading
    }
    
    func setProgress(_ progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
}



