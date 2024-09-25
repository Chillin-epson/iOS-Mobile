//
//  LoginView.swift
//  EpsonChillin
//
//  Created by 이승현 on 9/25/24.
//

import Foundation
import UIKit
import AuthenticationServices
import SnapKit

class LoginView: BaseView {
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "배경")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        return button
    }()
    
    override func configureView() {
        addSubview(backgroundImageView)
        addSubview(appleLoginButton)
        
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
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    
}
