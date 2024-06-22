//
//  MotionResultController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/22/24.
//

import UIKit
import SnapKit
import Gifu
import Alamofire

class MotionResultViewController: BaseViewController {
    
    var motionResultView = MotionResultView()
    var gifUrl: URL?
    
    override func loadView() {
        self.view = motionResultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.tintColor = .gray
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = UIColor(named: "MainBackGroundColor")
        
        if let gifUrl = gifUrl {
            loadGIF(from: gifUrl)
        }
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadGIF(from url: URL) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.motionResultView.gifImageView.animate(withGIFData: data)
                }
            case .failure(let error):
                print("Error loading GIF: \(error)")
            }
        }
    }
    
    override func configureView() {}
    
    override func setConstraints() {}
}


