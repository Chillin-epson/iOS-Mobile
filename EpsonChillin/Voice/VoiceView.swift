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
    
    let placeholderText = "색칠하고 싶은 그림을 말로 \n표현해보세요!"
    
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
        textView.text = placeholderText
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
        button.setTitle("그림 그리기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .white
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
        addSubview(voiceTitleLabel)
        addSubview(voiceSubTitleLabel)
        addSubview(textView)
        addSubview(recordButton)
        addSubview(drawingButton)
        addSubview(loadingImageView)
        addSubview(progressBar)
    }
    
    override func setConstraints() {
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
            make.height.equalTo(68)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
    }
    
    func removePlaceholder() {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func setPlaceholder() {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
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


