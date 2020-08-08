//
//  AddArtworkInputView.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/1.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

protocol AddArtworkInputViewDelegate: class {
    func handleCloseInputView()
    func moveToAddArtworkController()
}

private let reuseIdentifier = "AddArtworkInputViewCell"

class AddArtworkInputView: UIView {
    
    //MARK: - Properties
    weak var delegate: AddArtworkInputViewDelegate?
    
    private let titleBarView: UIView = {
        let view = UIView()
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .mainPurple
        closeButton.setDimensions(width: 24, height: 24)
        closeButton.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .mainPurple
        titleLabel.text = "Add Artwork"
        
        let addButton = UIButton(type: .system)
        addButton.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.setDimensions(width: 24, height: 24)
        addButton.addTarget(self, action: #selector(moveToAddArtwork), for: .touchUpInside)
        
        view.addSubview(closeButton)
        closeButton.anchor(left: view.leftAnchor, paddingLeft: 16)
        closeButton.centerY(inView: view)
        
        view.addSubview(titleLabel)
        titleLabel.centerY(inView: view)
        titleLabel.centerX(inView: view)
        
        view.addSubview(addButton)
        addButton.centerY(inView: view)
        addButton.anchor(right: view.rightAnchor, paddingRight: 16)
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        delegate?.handleCloseInputView()
    }
    
    @objc func moveToAddArtwork() {
        delegate?.moveToAddArtworkController()
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .mainBackground
        collectionView.register(AddArtworkInputViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        addSubview(titleBarView)
        titleBarView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 70)
        
        addSubview(collectionView)
        collectionView.anchor(top: titleBarView.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingLeft: 16)
        collectionView.showsHorizontalScrollIndicator = false
    }
}

//MARK: - UICollectionViewDataSource
extension AddArtworkInputView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddArtworkInputViewCell
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension AddArtworkInputView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: CollectionView Item did selected..")
    }
}

extension AddArtworkInputView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 16) / 2.5
        return CGSize(width: width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
