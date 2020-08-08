//
//  SupporterCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/8.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class SupporterCell: UITableViewCell {
    
    //MARK: - Properties
    private let tableImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .mainDarkGray
        iv.layer.cornerRadius = 12
        iv.setDimensions(width: 70, height: 50)
        
        return iv
    }()
    
    private let supporterName: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "MOA MUSEUM OF ART"
        label.setDimensions(width: 200, height: 15)
        
        return label
    }()
    
    private let supporterAddress: UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.font = .systemFont(ofSize: 10)
        label.text = "26-2 Momoyama-cho, Atami, Shizuoka, JAPAN"
        label.setDimensions(width: 300, height: 12)
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainBackground
        addSubview(tableImageView)
        tableImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12)
        
        let stack = UIStackView(arrangedSubviews: [supporterName, supporterAddress])
        addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 5
        stack.centerY(inView: tableImageView)
        stack.anchor(left: tableImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

