//
//  CommentCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/21.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    //MARK: - Properties
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .mainPurple
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "@heng_8130"
        label.textColor = .mainBackground
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "Nice work!"
        label.textColor = .mainBackground
        
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = ".16m"
        label.textColor = .mainAlphaGray
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainDarkGray
        selectionStyle = .none
        
//        addSubview(timestampLabel)
//        timestampLabel.anchor(right: rightAnchor, paddingRight: 12)
        
        let stack = UIStackView(arrangedSubviews: [userImageView, usernameLabel, messageLabel])
        stack.axis = .horizontal
        stack.spacing = 8

        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 12, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
