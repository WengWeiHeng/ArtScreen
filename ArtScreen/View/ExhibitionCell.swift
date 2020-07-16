//
//  ExhibitionCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private let exhibitionImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .mainPurple
        iv.layer.cornerRadius = 15
        iv.setDimensions(width: 164, height: 270)
        
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        addSubview(exhibitionImage)
        exhibitionImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
}
