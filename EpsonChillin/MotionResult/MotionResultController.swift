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
import Photos

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
        
        //view.backgroundColor = UIColor(named: "MainBackGroundColor")
        
        if let gifUrl = gifUrl {
            loadGIF(from: gifUrl)
        }
        
        configureView()
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
    
    override func configureView() {
        motionResultView.saveGifButton.addTarget(self, action: #selector(saveGifButtonTapped), for: .touchUpInside)
    }
    
    override func setConstraints() {}
    
    @objc func saveGifButtonTapped() {
        guard let gifUrl = gifUrl else { return }
        
        let alert = UIAlertController(title: "알림", message: "나의 앨범에 저장하시겠습니까?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "예", style: .default) { _ in
            AF.request(gifUrl).responseData { response in
                switch response.result {
                case .success(let data):
                    self.saveGifToLibrary(data: data)
                case .failure(let error):
                    print("Error downloading GIF: \(error)")
                }
            }
        }
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveGifToLibrary(data: Data) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("Authorization to access photo library denied")
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                let options = PHAssetResourceCreationOptions()
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: data, options: options)
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.showSaveSuccessAlert()
                    } else if let error = error {
                        self.showSaveErrorAlert(error: error)
                    } else {
                        self.showUnknownErrorAlert()
                    }
                }
            }
        }
    }
    
    func showSaveSuccessAlert() {
        let alert = UIAlertController(title: "저장 완료", message: "저장이 완료되었습니다!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showSaveErrorAlert(error: Error) {
        let alert = UIAlertController(title: "저장 실패", message: "저장 중 오류가 발생했습니다: \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showUnknownErrorAlert() {
        let alert = UIAlertController(title: "저장 실패", message: "저장 중 알 수 없는 오류가 발생했습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}




