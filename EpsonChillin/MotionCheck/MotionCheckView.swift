//
//  MotionCheckView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

import UIKit
import SnapKit

class MotionCheckView: BaseView {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "배경")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = UIImage(color: .clear, size: CGSize(width: 1, height: 1))
        return imageView
    }()
    
    lazy var motionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "1")
        button.setTitle("움직이게 하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        let cameraImage = UIImage(systemName: "camera.fill")
        button.setImage(cameraImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .white
        button.tintColor = .black
        return button
    }()
    
    lazy var removeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.image = UIImage(color: .clear, size: CGSize(width: 1, height: 1))
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var danceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("댄스", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var helloButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("안녕", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var jumpButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("점프", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var zombieButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setTitle("좀비", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    lazy var loadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "모션로딩")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(named: "motionProgressBar")
        progressView.trackTintColor = .lightGray
        progressView.isHidden = true
        return progressView
    }()
    
    override func configureView() {
        addSubview(backgroundImageView)
        addSubview(resultImageView)
        addSubview(motionButton)
        addSubview(cameraButton)
        addSubview(removeImageView)
//        addSubview(danceButton)
//        addSubview(helloButton)
//        addSubview(jumpButton)
//        addSubview(zombieButton)
        addSubview(loadingImageView)
        addSubview(progressBar)
        sendSubviewToBack(backgroundImageView)
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        resultImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(450)
        }
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(resultImageView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }
//        danceButton.snp.makeConstraints { make in
//            make.top.equalTo(cameraButton.snp.bottom).offset(15)
//            make.left.equalToSuperview().inset(20)
//            make.width.equalTo(80)
//            make.height.equalTo(40)
//        }
//        helloButton.snp.makeConstraints { make in
//            make.top.equalTo(cameraButton.snp.bottom).offset(15)
//            make.left.equalTo(danceButton.snp.right).offset(20)
//            make.width.equalTo(80)
//            make.height.equalTo(40)
//        }
//        jumpButton.snp.makeConstraints { make in
//            make.top.equalTo(cameraButton.snp.bottom).offset(15)
//            make.left.equalTo(helloButton.snp.right).offset(20)
//            make.width.equalTo(80)
//            make.height.equalTo(40)
//        }
//        zombieButton.snp.makeConstraints { make in
//            make.top.equalTo(cameraButton.snp.bottom).offset(15)
//            make.left.equalTo(jumpButton.snp.right).offset(20)
//            make.width.equalTo(80)
//            make.height.equalTo(40)
//        }
        motionButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        removeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            //make.leading.equalToSuperview().inset(0)
            make.height.equalTo(400)
            make.width.equalTo(300)
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
    @objc func sizeButtonTapped(_ sender: UIButton) {
        let buttons = [danceButton, helloButton, jumpButton, zombieButton]
        buttons.forEach { button in
            if button == sender {
                button.backgroundColor = .lightGray
            } else {
                button.backgroundColor = .white
            }
        }
    }
    
    func motionViewHidden(_ isLoad: Bool) {
        resultImageView.isHidden = isLoad
        danceButton.isHidden = isLoad
        helloButton.isHidden = isLoad
        jumpButton.isHidden = isLoad
        zombieButton.isHidden = isLoad
        cameraButton.isHidden = isLoad
        motionButton.isHidden = isLoad
        loadingImageView.isHidden = !isLoad
        progressBar.isHidden = !isLoad
    }
    func setProgress(_ progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
    
    
}

