//
//  ExhibitionCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private enum CellState {
    case expanded
    case collapsed
    
    var change: CellState {
        switch self {
        case .expanded: return .collapsed
        case .collapsed: return .expanded
        }
    }
}

protocol MainExhibitionCellDelegate: class {
    func itemDismissal(isDismissal: Bool)
}

class MainExhibitionCell: UICollectionViewCell {
    
    //MARK: - Properties
    private var initialFrame: CGRect?
    private var state: CellState = .collapsed
    static let cellSize = screenHeight * collectionViewCellHeightCoefficient
    private let popupOffset: CGFloat = (screenHeight - cellSize) / 2.0
    private var animationProgress: CGFloat = 0
    private var collectionView: UICollectionView?
    private var index: Int?
    
    weak var delegate: MainExhibitionCellDelegate?
    
    private lazy var animator: UIViewPropertyAnimator = {
        let VPA = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
        
        return VPA
    }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        pan.delegate = self
        
        return pan
    }()
    
    //MARK: - Exhibition Info Properties
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 28, height: 28)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    let exhibitionImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .mainDarkGray
        
        return iv
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "share").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.imageView?.setDimensions(width: 18, height: 18)
        button.backgroundColor = .mainDarkGray
        
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 50, height: 50)
        button.imageView?.setDimensions(width: 18, height: 18)
        button.backgroundColor = .mainPurple
        button.layer.maskedCorners = .layerMaxXMinYCorner
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    private lazy var followerStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Followers", countText: "6,962")
        return stack
    }()
    
    private lazy var likesStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Likes", countText: "25,104")
        return stack
    }()
    
    private lazy var visitedStack: UIStackView = {
        let stack = Utilities().customCountStackView(typeText: "Visited", countText: "304,501")
        return stack
    }()

    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 28, height: 28)
        iv.layer.cornerRadius = 28 / 2
        iv.backgroundColor = .mainPurple
        iv.image = #imageLiteral(resourceName: "coverImage")
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.text = "Jack Mauris"
        
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainPurple.cgColor
        button.setDimensions(width: 80, height: 28)
        button.layer.cornerRadius = 28 / 2
        button.alpha = 0
//        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        
        return button
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .mainPurple
        label.text = "Mauris hendrerit quam orci, sit amet posuere ante vestibulum sodales."
        label.numberOfLines = 3
        return label
    }()
    
    private let exhibitionIntroduction: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mainPurple
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum nulla sit amet elementum iaculis. Donec ac nisi dictum, hendrerit quam ut, consequat neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec hendrerit facilisis tortor nec pretium. "
        
        return label
    }()
    
    
    // StackView
    private lazy var actionButtonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [shareButton, likeButton])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        stack.alpha = 0
        
        return stack
    }()
    
    private lazy var socialDataStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [followerStack, likesStack, visitedStack])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alpha = 0
        
        return stack
    }()
    
    private lazy var userStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userImageView, usernameLabel])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alpha = 0
        
        return stack
    }()

    private lazy var exhibitionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [exhibitionTitleLabel, exhibitionIntroduction])
        stack.axis = .vertical
        stack.spacing = 14
        stack.alpha = 0
        
        return stack
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainBackground
        layer.cornerRadius = 24
        
        addSubview(exhibitionImage)
        exhibitionImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        exhibitionImage.setHeight(height: 500)
        exhibitionImage.layer.cornerRadius = 24
        
        addSubview(actionButtonStack)
        actionButtonStack.anchor(top: exhibitionImage.bottomAnchor, left: leftAnchor, paddingTop: -25)
        
        addSubview(socialDataStack)
        socialDataStack.anchor(bottom: actionButtonStack.bottomAnchor, right: rightAnchor, paddingRight: 16)
        
        addSubview(userStack)
        userStack.anchor(top: actionButtonStack.bottomAnchor, left: leftAnchor, paddingTop: 30, paddingLeft: 16)
        
        addSubview(followButton)
        followButton.centerY(inView: userStack)
        followButton.anchor(right: socialDataStack.rightAnchor)
        
        addSubview(exhibitionStack)
        exhibitionStack.anchor(top: userStack.bottomAnchor, left: userStack.leftAnchor, right: followButton.rightAnchor, paddingTop: 16)
        
        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16)
        
        addGestureRecognizer(panRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func popupViewPanned(recognizer: UIPanGestureRecognizer){
        switch recognizer.state{
        case .began:
            toggle()
            animator.pauseAnimation()
            
            //手勢中斷動畫
            animationProgress = animator.fractionComplete
        case .changed:
            let translation = recognizer.translation(in: collectionView)
            var fraction = -translation.y / popupOffset
            if state == .expanded{ fraction *= 1}
            if animator.isReversed{ fraction *= -1 }
            animator.fractionComplete = fraction
            
            //手勢中斷動畫
            animator.fractionComplete = fraction + animationProgress
            
        case .ended:
            let velocity = recognizer.velocity(in: self)
            let shouldComplete = velocity.y > 0
            if velocity.y == 0{
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            
            switch state{
            case .expanded:
                if !shouldComplete && !animator.isReversed{ animator.isReversed = !animator.isReversed }
                if shouldComplete && animator.isReversed{ animator.isReversed = !animator.isReversed }
            case .collapsed:
                if shouldComplete && !animator.isReversed{ animator.isReversed = !animator.isReversed }
                if !shouldComplete && animator.isReversed{ animator.isReversed = !animator.isReversed }
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default:
            ()
        }
    }
    
    @objc func handleDismissal() {
        toggle()
    }
    
    //MARK: - Helpers
    func configureData(with exhibition: Exhibition, collectionView: UICollectionView, index: Int) {
        exhibitionImage.sd_setImage(with: exhibition.exhibitionImageUrl)
        exhibitionTitleLabel.text = exhibition.name
        exhibitionIntroduction.text = exhibition.introduction
        
        self.collectionView = collectionView
        self.index = index
    }
    
    func toggle(){
        switch state{
        case .expanded:
            collapse()
        case .collapsed:
            expand()
        }
    }
    
    func collapse(){
        guard let collectionView = self.collectionView, let index = self.index else { return }
        
        animator.addAnimations {
            self.delegate?.itemDismissal(isDismissal: false)
            self.exhibitionImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            self.exhibitionImage.layer.cornerRadius = 24
            self.exhibitionImage.setHeight(height: 500)
            self.closeButton.alpha = 0
            self.actionButtonStack.alpha = 0
            self.socialDataStack.alpha = 0
            self.userStack.alpha = 0
            self.followButton.alpha = 0
            self.exhibitionStack.alpha = 0
            
            
            
            self.frame = self.initialFrame!
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)){
                leftCell.center.x += 50
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)){
                rightCell.center.x -= 50
            }
            
            self.layoutIfNeeded()
        }
        
        animator.addCompletion { (position) in
            switch position{
                case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = true
                collectionView.allowsSelection = true
            default:
                ()
            }
        }
        animator.startAnimation()
    }
    
    func expand(){
        guard let collectionView = self.collectionView, let index = self.index else{ return }
        
        animator.addAnimations {
            self.initialFrame = self.frame
            self.delegate?.itemDismissal(isDismissal: true)
            self.exhibitionImage.layer.maskedCorners = .layerMaxXMaxYCorner
            self.exhibitionImage.layer.cornerRadius = 60
            self.exhibitionImage.setHeight(height: screenHeight * 0.65)
            self.closeButton.alpha = 1
            self.actionButtonStack.alpha = 1
            self.socialDataStack.alpha = 1
            self.userStack.alpha = 1
            self.followButton.alpha = 1
            self.exhibitionStack.alpha = 1
            
            self.frame = CGRect(x: collectionView.contentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
            
            if let leftCell = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)){
                leftCell.center.x -= 50
            }
            
            if let rightCell = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)){
                rightCell.center.x += 50
            }
            
            self.layoutIfNeeded()
        }
        animator.addCompletion { (position) in
            switch position{
            case .end:
                self.state = self.state.change
                collectionView.isScrollEnabled = false
                collectionView.allowsSelection = false
            default:
                ()
            }
        }
        animator.startAnimation()
    }
}

//MARK: - UIGestureRecognizerDelegate
extension MainExhibitionCell: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panRecognizer.velocity(in: panRecognizer.view)).y) > abs((panRecognizer.velocity(in: panRecognizer.view)).x)
    }
}