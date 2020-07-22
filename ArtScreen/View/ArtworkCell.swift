//
//  ArtworkCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/20.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class ArtworkCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let artworkImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = false
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainBackground
        layer.cornerRadius = 15
        
        addSubview(artworkImageView)
        artworkImageView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
