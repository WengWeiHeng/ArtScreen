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

class ProfileFooter: UIView {
    
    //MARK: - Properties
    private var expansionState: ExpansionState = .NotExpanded
    
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

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainAlphaGray
        
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
        stack.centerY(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleSlideAction(recognizer: UIPanGestureRecognizer) {
        
    }
}

extension ProfileFooter: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
