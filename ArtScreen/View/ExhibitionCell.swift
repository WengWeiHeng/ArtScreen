//
//  ExhibitionCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/20.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainPurple
        layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
