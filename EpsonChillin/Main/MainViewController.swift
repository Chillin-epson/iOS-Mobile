//
//  ViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/15/24.
//

import UIKit


class MainViewController: UIViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "MainBackGroundColor")
        
        // 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topCardTapped))
        mainView.topCardImageView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(mediumCardTapped))
        mainView.mediumCardImageView.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(lowCardTapped))
        mainView.lowCardImageView.addGestureRecognizer(tapGesture3)
    }
    
    @objc func topCardTapped() {
        let voiceVC = VoiceViewController()
        let voiceNaviController = UINavigationController(rootViewController: voiceVC)
        voiceNaviController.modalPresentationStyle = .overFullScreen
        self.present(voiceNaviController, animated: true, completion: nil)
    }
    @objc func mediumCardTapped() {
        let scanVC = ScanViewController()
        let scanNaviController = UINavigationController(rootViewController: scanVC)
        scanNaviController.modalPresentationStyle = .overFullScreen
        self.present(scanNaviController, animated: true, completion: nil)
    }
    @objc func lowCardTapped() {
        let motionVC = MotionViewController()
        let motionNaviController = UINavigationController(rootViewController: motionVC)
        motionNaviController.modalPresentationStyle = .overFullScreen
        self.present(motionNaviController, animated: true, completion: nil)
    }

    
}

