//
//  ExhibitionUploadController.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/1.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class ExhibitionUploadController: UIViewController {
    
    //MARK: - Properties
    private let addArtworkInputView = AddArtworkInputView()
    private let exhibitionSettingView = ExhibitionSettingView()
    private let exhibitionEditView = ExhibitionEditView()
    private let exhibitionSendView = ExhibitionSendView()
    
    private var inputViewBottom = NSLayoutConstraint()
    private var settingViewBottom = NSLayoutConstraint()
    private var editViewBottom = NSLayoutConstraint()
    private var sendViewBottom = NSLayoutConstraint()
    
    private let inputViewHeight: CGFloat = 350
    private let settingViewHeight: CGFloat = 250
    private let editViewHeight: CGFloat = screenHeight * 0.9
    private let sendViewHeight: CGFloat = screenHeight * 0.5
    
    private lazy var customNavigationBarView: UIView = {
        let view = UIView()
        
        let leftButton = UIButton(type: .system)
        leftButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        leftButton.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
        leftButton.tintColor = .white
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        rightButton.addTarget(self, action: #selector(handleEditMoreAction), for: .touchUpInside)
        rightButton.tintColor = .white
        
        view.addSubview(leftButton)
        leftButton.anchor(left: view.leftAnchor, paddingLeft: 16)
        leftButton.centerY(inView: view)
        
        view.addSubview(rightButton)
        rightButton.centerY(inView: leftButton)
        rightButton.anchor(right: view.rightAnchor, paddingRight: 16)
        
        return view
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        label.text = "Commemorating the 70th Anniversary of his death Yoshida Hiroshi-Longing for Nature"
        
        return label
    }()
    
    private let announceIcon: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "notice")
        iv.setDimensions(width: 30, height: 30)
        
        return iv
    }()
    
    private let announceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = "You have not added any Artwork"
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let addArtworkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ADD", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainPurple
        button.setDimensions(width: 80, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleShowInputView), for: .touchUpInside)
        
        return button
    }()
    
    private let blackViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.alpha = 0
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
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
    @objc func handleBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleEditMoreAction() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.settingViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleDismissal() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0
            self.inputViewBottom.constant = self.inputViewHeight
            self.settingViewBottom.constant = self.settingViewHeight
            self.editViewBottom.constant = self.editViewHeight
            self.sendViewBottom.constant = self.sendViewHeight
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleShowInputView() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.inputViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .black
        view.addSubview(customNavigationBarView)
        customNavigationBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 30)

        view.addSubview(exhibitionTitleLabel)
        exhibitionTitleLabel.anchor(top: customNavigationBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        let stack = UIStackView(arrangedSubviews: [announceIcon, announceLabel, addArtworkButton])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        view.addSubview(stack)
        stack.centerX(inView: view)
        stack.centerY(inView: view)
        
        view.addSubview(blackViewButton)
        blackViewButton.addConstraintsToFillView(view)
        
        configureInputView()
    }
    
    func configureInputView() {
        view.addSubview(addArtworkInputView)
        addArtworkInputView.translatesAutoresizingMaskIntoConstraints = false
        addArtworkInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addArtworkInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        inputViewBottom = addArtworkInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inputViewHeight)
        inputViewBottom.isActive = true
        addArtworkInputView.heightAnchor.constraint(equalToConstant: inputViewHeight).isActive = true
        addArtworkInputView.layer.cornerRadius = 24
        addArtworkInputView.delegate = self
        
        view.addSubview(exhibitionSettingView)
        exhibitionSettingView.translatesAutoresizingMaskIntoConstraints = false
        exhibitionSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exhibitionSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        settingViewBottom = exhibitionSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: settingViewHeight)
        settingViewBottom.isActive = true
        exhibitionSettingView.heightAnchor.constraint(equalToConstant: settingViewHeight).isActive = true
        exhibitionSettingView.delegate = self
        
        view.addSubview(exhibitionEditView)
        exhibitionEditView.translatesAutoresizingMaskIntoConstraints = false
        exhibitionEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exhibitionEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        editViewBottom = exhibitionEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: editViewHeight)
        editViewBottom.isActive = true
        exhibitionEditView.heightAnchor.constraint(equalToConstant: editViewHeight).isActive = true
        exhibitionEditView.layer.cornerRadius = 24
        exhibitionEditView.delegate = self
        
        view.addSubview(exhibitionSendView)
        exhibitionSendView.translatesAutoresizingMaskIntoConstraints = false
        exhibitionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exhibitionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sendViewBottom = exhibitionSendView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: sendViewHeight)
        sendViewBottom.isActive = true
        exhibitionSendView.heightAnchor.constraint(equalToConstant: sendViewHeight).isActive = true
        exhibitionSendView.layer.cornerRadius = 24
        exhibitionSendView.delegate = self
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackAction))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleEditMoreAction))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}

//MARK: - AddArtworkInputViewDelegate
extension ExhibitionUploadController: AddArtworkInputViewDelegate {
    func moveToAddArtworkController() {
        print("DEBUG: move to add Artwork Controller..")
    }
    
    func handleCloseInputView() {
        handleDismissal()
    }
}

//MARK: - ExhibitionSettingViewDelegate
extension ExhibitionUploadController: ExhibitionSettingViewDelegate {
    func didTappedNewArtwork() {
        let controller = AddArtworkController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    func didTappedEditInfo() {
        print("didTappedEditInfo")
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.editViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    func didTappedSend() {
        print("didTappedSend")
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.sendViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    func didTappedCancel() {
        print("didTappedCancel")
        handleDismissal()
    }
}

//MARK: - ExhibitionEditViewDelegate
extension ExhibitionUploadController: ExhibitionEditViewDelegate {
    func didTappedEditInfo_cancel() {
        handleDismissal()
    }
}

//MARK: - ExhibitionSendViewDelegate
extension ExhibitionUploadController: ExhibitionSendViewDelegate {
    func didTappedExhibiSetting_Send_cancel() {
        handleDismissal()
    }  
}
