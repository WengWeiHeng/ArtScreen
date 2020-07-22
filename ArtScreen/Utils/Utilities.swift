//
//  Utileies.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class Utilities {
    func moreButtonView(withImage image: UIImage, text: String) -> UIView {
        let view = UIView()
        
        let label = UILabel()
        label.text = text
        label.textColor = .mainPurple
        label.font = UIFont.boldSystemFont(ofSize: 12)
        view.addSubview(label)
        label.anchor(left: view.leftAnchor)
        label.centerY(inView: view)
        
        let iv = UIImageView()
        iv.image = image
        iv.setDimensions(width: 5, height: 10)
        view.addSubview(iv)
        iv.centerY(inView: label)
        iv.anchor(left: label.rightAnchor, paddingLeft: 8)

        return view
    }
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView{
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .mainPurple
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.textColor = .mainPurple
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainPurple])
        
        return tf
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.mainPurple])
        
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.mainPurple]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
