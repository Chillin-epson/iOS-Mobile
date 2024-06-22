//
//  ScanCheckView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

import UIKit
import SnapKit

class ScanCheckView: BaseView {
    
    lazy var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        return imageView
    }()
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        let cameraImage = UIImage(systemName: "camera.fill")
        button.setImage(cameraImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
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
    
    override func configureView() {
        addSubview(resultImageView)
        addSubview(cameraButton)
        addSubview(removeImageView)
    }
    
    override func setConstraints() {
        resultImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(resultImageView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
//        removeImageView.snp.makeConstraints { make in
//            make.top.equalTo(resultImageView.snp.bottom).offset(0)
//            make.leading.equalToSuperview().inset(20)
//            make.width.height.equalTo(100)
//        }
        
        removeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(200)
        }
    }
}

