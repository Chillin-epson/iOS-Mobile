//
//  LoginViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 9/25/24.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()

        loginView.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
    
    override func loadView() {
        self.view = loginView
    }
    

    @objc func appleLoginButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self //로직
        controller.presentationContextProvider = self //로그인 창
        controller.performRequests()
    }

}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window! //윈도우에 꽉 차게
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    //애플 로그인이 성공한 경우 -> 메인 페이지로 이동 등..
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print(userIdentifier)
            print(fullName)
            print(email)
        }
    }
    
    //애플로 로그인 실패한 경우
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error")
    }
}



