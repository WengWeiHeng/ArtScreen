//
//  UserContentView.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/19.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import WaterfallLayout

private let exhibitionIdentifier = "ExhibitionCell"
private let artworkIdentifier = "ArtworkCell"
//private let headerIdentifier = "ContentHeader"

class UserContentView: UIView {
    
    //MARK: - Properties
    private let userInfoView = UserInfoView()
    private let contentHeader = ContentHeader()
    private let filterBar = FilterView()
    private var selectedFilterOptions: FilterOptions = .exhibitions
    
    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 100, right: 12)
//
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = .mainDarkGray
//        cv.delegate = self
//        cv.dataSource = self
//
//        return cv
        
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
//        layout.headerHeight = 60.0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainDarkGray
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditAction), for: .touchUpInside)
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36 / 2

        return button
    }()
    
    lazy var profileInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainAlphaGray
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 12, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        view.addSubview(bioLabel)
        bioLabel.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 12, width: 150)
        
        view.addSubview(editButton)
        editButton.anchor(bottom: bioLabel.bottomAnchor, right: view.rightAnchor, paddingRight: 12)
        
        view.addSubview(userInfoView)
        userInfoView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.setDimensions(width: 52, height: 52)
        
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.text = "翁 偉恆"
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "@Heng_Weng"
        
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "#Graphic Designer #Calligraphy #Programer #iOS #Swift"
        
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleDismissMenu() {
        //dismiss(animated: true, completion: nil)
        print("DEBUG: dismissal..")
    }
    
    @objc func handleEditAction() {
        print("DEBUG: Profile Cover is Editting..")
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .mainDarkGray
        
        addSubview(profileInfoView)
        profileInfoView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 280)
        profileInfoView.alpha = 0
        
        addSubview(contentHeader)
        contentHeader.anchor(top: profileInfoView.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 70)
    }
    
    func configureCollectionView() {
        collectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: exhibitionIdentifier)
        collectionView.register(ArtworkCell.self, forCellWithReuseIdentifier: artworkIdentifier)
        
        addSubview(collectionView)
        collectionView.anchor(top: contentHeader.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        
        addSubview(filterBar)
        filterBar.centerX(inView: self)
        filterBar.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, width: 230, height: 40)
    }
}

//MARK: - CollectionView DataSource
extension UserContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch selectedFilterOptions {
        case .exhibitions:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: exhibitionIdentifier, for: indexPath) as! ExhibitionCell

            return cell
        case .artworks:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: artworkIdentifier, for: indexPath) as! ArtworkCell
            
            return cell
        }
    }
}

//MARK: - CollectionView Delegate
extension UserContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell did Selected..")
    }
}

extension UserContentView: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
//        switch section {
//        case 0: return .waterfall(column: 2, distributionMethod: .balanced)
//        case 1: return .waterfall(column: 2, distributionMethod: .balanced)
//        default: return .waterfall(column: 2, distributionMethod: .balanced)
//        }
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return WaterfallLayout.automaticSize
    }
}

extension UserContentView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: frame.width / 2, height: collectionView.frame.height - 100)
    }
}
