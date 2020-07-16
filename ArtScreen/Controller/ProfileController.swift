//
//  ProfileController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/16.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    //MARK: - Properties
    let userCoverView = UserCoverView()
    let profileFooter = ProfileFooter()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleDismissMenu), for: .touchUpInside)
        
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditAction), for: .touchUpInside)
        
        
        return button
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors
    @objc func handleDismissMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEditAction() {
        print("DEBUG: Profile Cover is Editting..")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainDarkGray
        
        view.addSubview(userCoverView)
        userCoverView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 750)
        
        view.addSubview(profileFooter)
        profileFooter.anchor(top: userCoverView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 90)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 12)
        
        view.addSubview(editButton)
        editButton.anchor(bottom: userCoverView.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 12)
        editButton.setDimensions(width: 100, height: 36)
        editButton.layer.cornerRadius = 36 / 2
    
    }
}
