//
//  MotionView.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//
import UIKit
import SnapKit

class MotionView: BaseView {
    
    lazy var voiceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "움직이는 그림을 만들어보세요!"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    lazy var voiceSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "움직이게 하고 싶은 그림을 선택해주세요"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        view.backgroundColor = .clear //UIColor(named: "White")
        return view
    }()
    
    
    override func configureView() {
        addSubview(voiceTitleLabel)
        addSubview(voiceSubTitleLabel)
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        voiceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        voiceSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(voiceTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(voiceSubTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let padding: CGFloat = 20
        let itemsPerRow: CGFloat = 3
        let itemSpacing: CGFloat = 10
        let totalSpacing: CGFloat = (itemsPerRow - 1) * itemSpacing + padding * 2
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / itemsPerRow
        
        layout.itemSize = CGSize(width: 190, height: 270)
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        return layout
    }

    
}



