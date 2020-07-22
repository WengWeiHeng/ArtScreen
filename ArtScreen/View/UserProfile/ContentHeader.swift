//
//  ContentHeader.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/20.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class ContentHeader: UICollectionReusableView {
    
    //MARK: - properties
    var option: FilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.text = "Exhibition"
        
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleAddAction), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 12, paddingBottom: 8)
        
        addSubview(addButton)
        addButton.centerY(inView: titleLabel)
        addButton.anchor(right: rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleAddAction() {
        print("DEBUG: add action..")
    }
}
