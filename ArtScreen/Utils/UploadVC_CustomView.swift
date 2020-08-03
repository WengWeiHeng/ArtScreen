//
//  UploadVC_CustomView.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/1.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class UploadVC_CustomView: UIView {
    
    var imgButton: UIButton!
    var titleLabel: UILabel!
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init (frame : CGRect) {
        super.init(frame : frame)
          
        
        //imgButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 80))
        imgButton = UIButton()
        imgButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imgButton.heightAnchor.constraint(equalToConstant: 240).isActive = true
        imgButton.layer.cornerRadius = 20
        imgButton.setTitle("imgButton", for: .normal)
        imgButton.setTitleColor(.purple, for: .normal)
        imgButton.setImage(UIImage(named: "imgSample02"), for: .normal)
//        imgButton.backgroundColor = .yellow
        imgButton.addTarget(self, action: #selector(tapImgButton), for: .touchUpInside)
        //self.addSubview(imgButton)
        
        
        //titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        titleLabel = UILabel()
        titleLabel.text = "My ArtWork Title"
        titleLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        //titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        titleLabel.textColor = .purple
        titleLabel.textAlignment = .center
//        titleLabel.backgroundColor = .green
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        //self.addSubview(titleLabel)
        
        let stackView = UIStackView(frame: .zero)
        //view.addSubview(stackView)
        self.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        //stackView.distribution = .fill
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(imgButton)
        stackView.addArrangedSubview(titleLabel)
        
//        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        //titleLabel.topAnchor.constraint(equalTo: imgButton.bottomAnchor, constant: 10).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imgButton.translatesAutoresizingMaskIntoConstraints = false
        
    }

    
    @objc func tapImgButton() {
        print("imgButton be tapped")
    }

}

