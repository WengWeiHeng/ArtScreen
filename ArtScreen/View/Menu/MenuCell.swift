//
//  MenuCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/15.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    //MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 22, height: 22)
        
        return iv
    }()
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainPurple
        
        let stack = UIStackView(arrangedSubviews: [iconImageView, optionLabel])
        stack.spacing = 8
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingLeft: 12)
        stack.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
