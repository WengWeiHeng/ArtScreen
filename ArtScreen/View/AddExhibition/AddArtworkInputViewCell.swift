//
//  AddArtworkInputViewCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/1.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class AddArtworkInputViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let artworkImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .mainPurple
        iv.layer.cornerRadius = 15
        
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(artworkImageView)
        artworkImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
