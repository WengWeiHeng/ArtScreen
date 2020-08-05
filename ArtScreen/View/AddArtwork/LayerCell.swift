//
//  LayerCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/5.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class LayerCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let layerImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .mainPurple
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 36, height: 36)
        
        return iv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(layerImageView)
        layerImageView.centerY(inView: self)
        layerImageView.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
