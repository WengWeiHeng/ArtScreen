//
//  ExhibitionCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class MainExhibitionCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private var widthOffset: CGFloat = UIScreen.main.bounds.width / 2
    private var paddingOffset: CGFloat = 12 * 2
    
    let exhibitionImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .mainDarkGray
        
        return iv
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(exhibitionImage)
        exhibitionImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
//        exhibitionImage.setDimensions(width: widthOffset - paddingOffset, height: 300)
        exhibitionImage.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
}
