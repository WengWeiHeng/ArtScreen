//
//  ExhibitionCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
//import GravitySliderFlowLayout

class MainExhibitionCell: UICollectionViewCell {
    
    //MARK: - Properties
    var exhibition: Exhibition? {
        didSet {
            configureData()
        }
    }
    
    let exhibitionImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainDarkGray
        
        return iv
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(exhibitionImage)
        exhibitionImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        exhibitionImage.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureData() {
        guard let exhibition = exhibition else { return }
        exhibitionImage.sd_setImage(with: exhibition.exhibitionImageUrl)
    }
}
