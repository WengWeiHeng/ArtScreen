//
//  ProfileInputView.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/17.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reusesIdentifier = "ProfileInputViewCell"
private let headerIdentifier = "ProfileCollectionHeader"

class ProfileInputView: UIView {
    
    //MARK: - Properties
    private let collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: 375, height: 200)
        let view = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
//        view.delegate = self
        
        return view
        
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reusesIdentifier)
        collectionView.register(ProfileInnerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - UICollectionViewDataSource
extension ProfileInputView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusesIdentifier, for: indexPath)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ProfileInputView: UICollectionViewDelegate {
    
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
extension ProfileInputView: UICollectionViewDelegateFlowLayout{
    
    //Collection header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: self.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width, height: 300)
    }
}


