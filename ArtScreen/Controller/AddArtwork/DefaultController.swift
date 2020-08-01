//
//  DefaultController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class DefaultController: UIViewController {
    
    //MARK: - Properties
    var customProtocol: CustomProtocol?
    
    let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.backgroundColor = .white
        return stack
    }()
    
    let settingView : UIView = {
        let view = UIView()
        let buttonPhotoLibrary : UIButton = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setImage(#imageLiteral(resourceName: "photo"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonPhotoLibrary), for: .touchUpInside)
            return button
        }()
        
        let buttonSendImage : UIButton = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setImage(#imageLiteral(resourceName: "Send"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonSendImage), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(buttonPhotoLibrary)
        view.addSubview(buttonSendImage)
        buttonPhotoLibrary.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 12, width: 70, height: 40)
        buttonSendImage.anchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 12, width: 70, height: 40)
        return view
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let buttonName = ["Paint","Font","Style","Color","Delete"]
        for i in 0..<buttonName.count {
            let button = UIButton()
            button.setDimensions(width: 60, height: 60)
            button.setTitle(buttonName[i], for: .normal)
//                button.backgroundColor = .cyan
            button.setImage(UIImage(named: buttonName[i]), for: .normal)
            button.setTitleColor(.black, for: .normal)
            stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
        stackView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 15, paddingBottom: 30, width: 60 * 5 + 8 * 4, height: 60)
        view.addSubview(settingView)
        settingView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 40)
        view.addSubview(imageView)
        imageView.anchor(top: settingView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, height: screenWidth)
    }
    
    //MARK: - Selectors
    @objc func tapbuttonPhotoLibrary() {
        print("Tapped PhotoLibrary Button...")
//        dismiss(animated: true, completion: nil)
        self.dismiss(animated: true) {
            self.customProtocol?.dismissed()
        }
    }
    
    @objc func tapbuttonSendImage() {
        print("Tapped Send Button...")
    }
    
    //MARK: - Helpers
}

