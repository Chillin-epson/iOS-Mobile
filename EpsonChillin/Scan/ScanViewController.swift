//
//  ScanViewController.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

import UIKit
import Alamofire

class ScanViewController: BaseViewController {
    
    var scanView = ScanView()
    var drawings: [Drawing] = []
    var currentPage = 1
    var isLoading = false
    var hasMoreData = true
    
    override func loadView() {
        self.view = scanView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonTapped))
        backButton.tintColor = .gray
        navigationItem.leftBarButtonItem = backButton
        
        //view?.backgroundColor = UIColor(named: "MainBackGroundColor")
        scanView.collectionView.delegate = self
        scanView.collectionView.dataSource = self
        
        fetchDrawings(page: currentPage)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchDrawings(page: Int) {
        guard !isLoading, hasMoreData else { return }
        isLoading = true
        
        let url = "https://api.zionhann.shop/app/chillin/drawings"
        let parameters: [String: Any] = ["type": "GENERATED", "page": page]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            self.isLoading = false
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let data = json["data"] as? [[String: Any]] {
                    let newDrawings = data.compactMap { Drawing(dictionary: $0) }
                    if newDrawings.isEmpty {
                        self.hasMoreData = false
                    } else {
                        self.drawings.append(contentsOf: newDrawings)
                        self.scanView.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

extension ScanViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drawings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let drawing = drawings[indexPath.item]
        cell.configure(with: drawing)
        return cell
    }
    
    // MARK: - 페이지네이션
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let offsetY = scrollView.contentOffset.y
    //        let contentHeight = scrollView.contentSize.height
    //        let height = scrollView.frame.size.height
    //
    //        if offsetY > contentHeight - height * 2 { // 약간의 여유를 둡니다.
    //            currentPage += 1
    //            fetchDrawings(page: currentPage)
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drawing = drawings[indexPath.item]
        let scanCheckVC = ScanCheckViewController()
        scanCheckVC.drawing = drawing
        scanCheckVC.drawingId = drawing.drawingId
        
        let scanCheckNaviController = UINavigationController(rootViewController: scanCheckVC)
        scanCheckNaviController.modalPresentationStyle = .overFullScreen
        self.present(scanCheckNaviController, animated: true, completion: nil)
    }
}

// MARK: - Drawing구조체, 딕셔너리
struct Drawing {
    let drawingId: Int
    let url: String
    let prompt: String?
    
    init?(dictionary: [String: Any]) {
        guard let drawingId = dictionary["drawingId"] as? Int,
              let url = dictionary["url"] as? String else {
            return nil
        }
        self.drawingId = drawingId
        self.url = url
        self.prompt = dictionary["prompt"] as? String
    }
}


