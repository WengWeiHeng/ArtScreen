//
//  MainCollectionHeader.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class MainCollectionHeader: UICollectionReusableView {
    
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .mainPurple
        label.text = "EXHIBITION"
        
        return label
    }()
    
    private lazy var moreView: UIView = {
        let view = Utilities().moreButtonView(withImage: #imageLiteral(resourceName: "moreRight"), text: "MORE")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMoreAction))
        view.addGestureRecognizer(tap)

        return view
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 12, paddingBottom: 33)
        
        addSubview(moreView)
        moreView.anchor(bottom: titleLabel.bottomAnchor, right: rightAnchor, paddingRight: 12)
        moreView.setDimensions(width: 50, height: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleMoreAction() {
        print("DEBUG: More Exhibition..")
    }
}
