//
//  PrintView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

import UIKit
import SnapKit

class ScanView: BaseView {
    
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "배경")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var voiceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "생성한 그림을 볼 수 있어요!"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    lazy var voiceSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "스캐너로 스캔한 이미지들을 확인할 수 있어요"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        view.backgroundColor = UIColor(named: "White")
        return view
    }()
    
    
    
    override func configureView() {
        addSubview(backgroundImageView)
        addSubview(voiceTitleLabel)
        addSubview(voiceSubTitleLabel)
        addSubview(collectionView)
//        addSubview(scanImageButton)
//        addSubview(createImageButton)
        sendSubviewToBack(backgroundImageView)
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(-10)
            make.right.equalToSuperview().inset(-10)
            make.bottom.equalToSuperview().inset(-10)
        }
        voiceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        voiceSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(voiceTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(voiceSubTitleLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 20
        let itemsPerRow: CGFloat = 2
        let itemSpacing: CGFloat = 10
        let totalSpacing: CGFloat = (itemsPerRow - 1) * itemSpacing + padding * 2
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / itemsPerRow
        
        layout.itemSize = CGSize(width: itemWidth, height: 250)
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        return layout
    }

    
}
