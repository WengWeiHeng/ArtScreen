//
//  ProfileInnerController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/17.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reusesIdentifier = "ProfileInputViewCell"
private let headerIdentifier = "ProfileInnerHeader"

class ProfileInnerController: UIViewController {
    
    //MARK: - Properties
    private let userInfoView = UserInfoView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainDarkGray
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainAlphaGray
        
        view.addSubview(userInfoView)
        userInfoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 213)
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(ProfileExhibitionCell.self, forCellWithReuseIdentifier: reusesIdentifier)
        collectionView.register(ProfileInnerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
        
        view.addSubview(collectionView)
        collectionView.anchor(top: userInfoView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }
    
}

//MARK: - UICollectionViewDataSource
extension ProfileInnerController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusesIdentifier, for: indexPath) as! ProfileExhibitionCell
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ProfileInnerController: UICollectionViewDelegate{
    
    //MARK: - Header Delegate
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileInnerHeader

        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print("DEBUG: Cell did selected..")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileInnerController: UICollectionViewDelegateFlowLayout{
    
    //Collection header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 300)
    }
}



