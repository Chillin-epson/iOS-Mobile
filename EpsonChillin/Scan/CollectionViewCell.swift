//
//  CollectionViewCell.swift
//  EpsonChillin
//
//  Created by 이승현 on 6/21/24.
//

import UIKit

class CollectionViewCell: BaseCollectionViewCell {
    
    let scanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func configureView() {
        contentView.addSubview(scanImageView)
    }
    
    override func setConstraints() {
        scanImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(0)
            make.leading.equalTo(contentView.snp.leading).offset(0)
            make.trailing.equalTo(contentView.snp.trailing).offset(0)
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
        }
    }
    func configure(with drawing: Drawing) {
        if let url = URL(string: drawing.url) {
            scanImageView.kf.setImage(with: url)
        }
    }
    
}
