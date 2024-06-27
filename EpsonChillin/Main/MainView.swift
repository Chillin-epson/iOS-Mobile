//
//  MainView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/15/24.
//

import Foundation
import UIKit
import SnapKit

class MainView: BaseView {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "배경")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var titleLabelView: UILabel = {
        let label = UILabel()
        label.text = "오늘은 어떤 그림을 \n그려볼까요? 🎨"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    lazy var topCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "메인1")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var mediumCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "new2")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var lowCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "메인3")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func configureView() {
        addSubview(backgroundImageView)
        addSubview(titleLabelView)
        addSubview(topCardImageView)
        addSubview(mediumCardImageView)
        addSubview(lowCardImageView)
        // 배경 이미지가 다른 뷰들 아래에 위치하도록 설정
        sendSubviewToBack(backgroundImageView)
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(-10)
            make.right.equalToSuperview().inset(-10)
            make.bottom.equalToSuperview().inset(-10)
        }
        titleLabelView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(0)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(20)
            make.height.equalTo(80)
        }
        topCardImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabelView.snp.bottom).offset(10)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).inset(20)
            make.height.equalTo(248)
        }
        mediumCardImageView.snp.makeConstraints { make in
            make.top.equalTo(topCardImageView.snp.bottom).offset(10)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).inset(20)
            make.height.equalTo(180)
        }
        lowCardImageView.snp.makeConstraints { make in
            make.top.equalTo(mediumCardImageView.snp.bottom).offset(10)
            make.left.equalTo(safeAreaLayoutGuide.snp.left).offset(20)
            make.right.equalTo(safeAreaLayoutGuide.snp.right).inset(20)
            make.height.equalTo(180)
        }
        
    }
    
    
}

