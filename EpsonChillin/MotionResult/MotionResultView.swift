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

    lazy var gifImageView: GIFImageView = {
        let imageView = GIFImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(color: .white, size: CGSize(width: 1, height: 1))
        return imageView
    }()

    
    override func configureView() {
        addSubview(gifImageView)
    }
    
    override func setConstraints() {
        gifImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(500)
        }
    }
    
}
