//
//  ProfileFooter.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/16.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private enum ExpansionState {
    case NotExpanded
    case FullyExpanded
    
    var change: ExpansionState {
        switch self {
        case .NotExpanded:
            return .FullyExpanded
        case .FullyExpanded:
            return .NotExpanded
        }
    }
}

class UserInfoView: UICollectionReusableView {
    
    //MARK: - Properties
    private var expansionState: ExpansionState = .NotExpanded
    
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
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36 / 2
        
        
        return button
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
        label.text = "#Graphic Designer #Calligraphy #Programer #Swift"
        
        return label
    }()
    
    private let followCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = "25.602"
        
        return label
    }()
    
    private let artworkCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = "162"
        
        return label
    }()
    
    private let visitedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = "203,301"
        
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Followers"
        
        return label
    }()
    
    private let artworkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Artwork"
        
        return label
    }()
    
    private let visitedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.text = "Visited"
        
        return label
    }()
    
    private lazy var panRecongnizer: UIPanGestureRecognizer = {
        let pr = UIPanGestureRecognizer()
        pr.addTarget(self, action: #selector(handleSlideAction(recognizer:)))
        pr.delegate = self
        
        return pr
    }()
    
    private lazy var animator: UIViewPropertyAnimator = {
        let vpa = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
        
        return vpa
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainAlphaGray
        
        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        
        let nameStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        nameStack.distribution = .fillEqually
        nameStack.spacing = 4
        nameStack.axis = .vertical
        
        addSubview(nameStack)
        nameStack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        addSubview(bioLabel)
        bioLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12, width: 200)
        
        addSubview(editButton)
        editButton.anchor(bottom: bioLabel.bottomAnchor, right: closeButton.rightAnchor)
        
        let followerStack = UIStackView(arrangedSubviews: [followCountLabel, followerLabel])
        followerStack.axis = .vertical
        followerStack.spacing = 4
        followerStack.alignment = .center
        
        let artworkStack = UIStackView(arrangedSubviews: [artworkCountLabel, artworkLabel])
        artworkStack.axis = .vertical
        artworkStack.spacing = 4
        artworkStack.alignment = .center
        
        let visitedStack = UIStackView(arrangedSubviews: [visitedCountLabel, visitedLabel])
        visitedStack.axis = .vertical
        visitedStack.spacing = 4
        visitedStack.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [followerStack, artworkStack, visitedStack])
        stack.spacing = 70
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(bottom: bottomAnchor, paddingBottom: 12)  
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleDismissMenu() {
        print("DEBUG: Dismissal..")
    }
    
    @objc func handleEditAction() {
        print("DEBUG: Profile Cover is Editting..")
    }
    
    @objc func handleSlideAction(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            break
        case .changed:
            break
        case .ended:
            break
        default:
            print("DEBUG: fatal Error..")
        }
    }
}

extension UserInfoView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
