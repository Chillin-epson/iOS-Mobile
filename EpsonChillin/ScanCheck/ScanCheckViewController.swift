//
//  ScanCheckViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

import UIKit
import Kingfisher

class ScanCheckViewController: BaseViewController {
    
    let scanCheckView = ScanCheckView()
    var drawing: Drawing?
    
    override func loadView() {
        self.view = scanCheckView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "MainBackGroundColor")
        
        if let drawing = drawing, let url = URL(string: drawing.url) {
            scanCheckView.resultImageView.kf.setImage(with: url)
        }
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.tintColor = .gray
        navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

