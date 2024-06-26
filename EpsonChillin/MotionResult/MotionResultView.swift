//
//  MotionView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/22/24.
//

import UIKit
import SnapKit
import Gifu

class MotionResultView: BaseView {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "배경")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var gifImageView: GIFImageView = {
        let imageView = GIFImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        return imageView
    }()
    lazy var saveGifButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "인쇄하기 비활")
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(UIColor(named: "인쇄하기 활성"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "인쇄하기 활성")?.cgColor
        button.isHidden = false
        return button
    }()
    
    override func configureView() {
        addSubview(backgroundImageView)
        addSubview(gifImageView)
        addSubview(saveGifButton)
        sendSubviewToBack(backgroundImageView)
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gifImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
        saveGifButton.snp.makeConstraints { make in
            make.top.equalTo(gifImageView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
    }
    
}
