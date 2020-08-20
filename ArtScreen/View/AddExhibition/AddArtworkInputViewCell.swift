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
    var artwork: Artwork? {
        didSet {
            configureData()
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainPurple
        iv.layer.cornerRadius = 15
        
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    func configureData() {
        guard let artwork = artwork else { return }
        imageView.sd_setImage(with: artwork.artworkImageUrl)
    }
}
