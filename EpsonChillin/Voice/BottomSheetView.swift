//
//  BottomSheetView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/15/24.
//

import UIKit
import SnapKit
import Lottie

class BottomSheetView: UIView {
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Flow 6")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let recognizedTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "recordButton") {
            button.setImage(image, for: .normal)
        } else {
            print("녹음 image not found")
        }
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.3
        
        addSubview(animationView)
        addSubview(recognizedTextLabel)
        addSubview(stopButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        recognizedTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(34)
        }
        
        animationView.snp.makeConstraints { make in
            make.top.equalTo(recognizedTextLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(45)
        }
        
        stopButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        if let imageView = stopButton.imageView {
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(90)
            }
        }
    }
    
    func updateText(_ text: String) {
        recognizedTextLabel.text = text
    }
    
    func animateSheet() {
        animationView.play()
    }
    
    @objc private func stopButtonTapped() {
        
    }
    
    func getRecognizedText() -> String {
        return recognizedTextLabel.text ?? ""
    }
    
    func setAnimationColor() {
        // Lottie 애니메이션의 특정 색상을 오렌지색으로 변경
        let keypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        let colorProvider = ColorValueProvider(UIColor.orange.lottieColorValue)
        animationView.setValueProvider(colorProvider, keypath: keypath)
    }
    
}

extension UIColor {
    var lottieColorValue: LottieColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return LottieColor(r: Double(red), g: Double(green), b: Double(blue), a: Double(alpha))
    }
}







