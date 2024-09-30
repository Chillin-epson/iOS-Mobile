//
//  LoginViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 9/25/24.
//

import UIKit
import AuthenticationServices
import Alamofire

/*
 소셜 로그인(페북/구글/카카오..), 애플 로그인 구현 필수 (미구현 시 리젝사유)
 (ex. 인스타그램은 페북꺼니까(?) 애플 안붙여도 괜찮음!)
 자체 로그인만 구성이 되어 있다면, 애플 로그인 구현 필수 아님
 => 개인 개발자 계정이 있어야 테스트 가능
 */

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
    
    //애플로 로그인 성공한 경우 -> 메인 페이지로 이동 등..
    //처음 시도: 계속, email, fullname 제공 (사용자 성공. email. name -> 서버
    //두번째 시도: 로그인할래요?, email, fullname, nil값으로 온다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            print(appleIDCredential)
            
            let useridentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            guard let codeData = appleIDCredential.authorizationCode,
                  let codeString = String(data: codeData, encoding: .utf8),
                  let tokenData = appleIDCredential.identityToken,
                  let tokenToString = String(data: tokenData, encoding: .utf8) else {
                print("Authorization Code or Token Error")
                return
            }
            
            
            print(useridentifier)
            print(fullName ?? "No fullName")
            print(email ?? "No email")
            print(tokenToString)
            
            if email?.isEmpty ?? true {
                let result = decode(jwtToken: tokenToString)["email"] as? String ?? ""
                print(result) //UserDefualt
            }
            
            //이메일, 토큰, 이름 -> UserDefaults & API로 서버에 POST
            //서버에 Request 후 Response를 받게 되면 성공시 화면 전환
            
            UserDefaults.standard.set(useridentifier, forKey: "User")
            
            // API로 서버에 POST 요청
            let parameters: [String: Any] = [
                "code": codeString,
            ]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let url = "https://api.zionhann.com/chillin/auth/oauth2/token"
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Login Success: \(value)")
                    
                    // 서버 응답에서 토큰을 추출
                    if let json = value as? [String: Any],
                       let token = json["token"] as? String,
                       let grantType = json["grantType"] as? String {
                        print("Token: \(token)")
                        print("Grant Type: \(grantType)")
                        
                        // 이후 액션 처리 (예: 화면 전환)
                        DispatchQueue.main.async {
                            self.present(MainViewController(), animated: true)
                        }
                    }
                    
                case .failure(let error):
                    // 에러 처리
                    print("Login Error: \(error.localizedDescription)")
                    if let data = response.data, let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Error Response: \(errorResponse)")
                    }
                }
            }
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("Username: \(username), Password: \(password)")
            
        default: break
        }
    }
    
    //애플로 로그인 실패한 경우
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Login Failed \(error.localizedDescription)")
    }
}

private func decode(jwtToken jwt: String) -> [String: Any] {
    
    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }
        
        return payload
    }
    
    let segments = jwt.components(separatedBy: ".")
    return decodeJWTPart(segments[1]) ?? [:]
}




