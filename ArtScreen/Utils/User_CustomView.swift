//
//  User_CustomView.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/1.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class User_CustomerView: UIView {
    
    var userImg: UIImageView!
    var titleLabel: UILabel!
    var sendButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let containerView = UIView()
        containerView.layer.cornerRadius = 30
        containerView.layer.masksToBounds = true
        containerView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let imgDefault = UIImage(named: "userSample01")
        userImg = UIImageView()
        userImg.contentMode = UIView.ContentMode.scaleAspectFit
        userImg.image = imgDefault
        containerView.addSubview(userImg)
        userImg.frame = containerView.bounds
        userImg.contentMode = .scaleAspectFill
        userImg.translatesAutoresizingMaskIntoConstraints = false
        
        userImg.widthAnchor.constraint(equalToConstant: 60).isActive = true
        userImg.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
//        userImg.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        userImg.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        titleLabel = UILabel()
        titleLabel.text = "Heng_Weng"
        titleLabel.textColor = .purple
        titleLabel.textAlignment = .left
//        titleLabel.backgroundColor = .green
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 210).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: userImg.rightAnchor, constant: 20).isActive = true
        
        sendButton = UIButton()
        sendButton.setImage(UIImage(named: "send_word"), for: .normal)
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        //sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.translatesAutoresizingMaskIntoConstraints = true
//        sendButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        sendButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(tapSendButton), for: .touchUpInside)
        
        
        let stackView = UIStackView(frame: .zero)
        self.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(sendButton)
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
//        userImg.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
//        userImg.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
//
//        titleLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: userImg.rightAnchor, constant: 20).isActive = true
//
//        sendButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
//        sendButton.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func tapSendButton() {
        print("sendButton be tapped")
    }
    
}

