//
//  PrintView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

import UIKit
import SnapKit

class ScanView: BaseView {
    
    lazy var printLoadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "프린트로딩")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    

    
    override func configureView() {
        addSubview(printLoadingImageView)

    }
    
    override func setConstraints() {
        printLoadingImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(390)
            make.left.right.equalToSuperview().inset(20)
        }
        
    }
    
}
    
    
