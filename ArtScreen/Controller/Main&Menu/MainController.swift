//
//  MainController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MainExhibitionCell"
private let headerIdentifier = "MainCollectionHeader"

protocol MainControllerDelegate: class {
    func handleMenuToggle()
}

class MainController: UICollectionViewController {
    
    //MARK: - Properties
    weak var delegate: MainControllerDelegate?
    
    private let menuButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), for: .normal)
         button.setDimensions(width: 32, height: 20)
         button.addTarget(self, action: #selector(handleMenuAction), for: .touchUpInside)
        
         return button
     }()
    
     private let searchButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
         button.setDimensions(width: 22, height: 24)
         button.addTarget(self, action: #selector(handleSearchAction), for: .touchUpInside)
        
         return button
     }()
    
     private let uploadButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal), for: .normal)
         button.setDimensions(width: 24, height: 24)
         button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)
        
         return button
     }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleMenuAction() {
        delegate?.handleMenuToggle()
    }
    
    @objc func handleSearchAction() {
        let controller = SearchController()
        let nav = UINavigationController(rootViewController: controller)
        nav.isModalInPresentation = false
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleUploadAction() {
        print("DEBUG: handle upload action..")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        
        view.addSubview(menuButton)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [searchButton, uploadButton])
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.centerY(inView: menuButton)
        stack.anchor(right: view.rightAnchor, paddingRight: 12)
        
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .mainBackground
        collectionView.register(MainExhibitionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(MainCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

//MARK: - UICollectionViewDataSource
extension MainController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainExhibitionCell
                
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MainController {
    
    //MARK: - Header Delegate
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! MainCollectionHeader
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("DEBUG: Cell did selected..")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainController: UICollectionViewDelegateFlowLayout{
    
    //Collection header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: view.frame.width, height: 154)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 300)
    }
}
