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
}
