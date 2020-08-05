//
//  AnimateController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "LayerCell"

class AnimateController: UIViewController,UIScrollViewDelegate {
    
    //MARK: - Properties
    var customProtocol: CustomProtocol?
    let featureToolBarView = FeatureToolBarView()
    let animateToolBarView = AnimateToolBarView()

    private var isSelected: Bool = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .init(white: 1, alpha: 0.5)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.layer.cornerRadius = 56 / 2
        cv.register(LayerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        return cv
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "delete").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 36, height: 36)
        button.addTarget(self, action: #selector(handleDeleteLayerItem), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var layerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [collectionView, deleteButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alpha = 0
        
        return stack
    }()
    
    let settingView : UIView = {
       let view = UIView()
        let buttonPhotoLibrary : UIButton = {
            let button = UIButton()
//            button.backgroundColor = .white
//            button.setTitleColor(.black, for: .normal)
            button.setImage(#imageLiteral(resourceName: "Library"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonPhotoLibrary), for: .touchUpInside)
            return button
        }()
        
        let buttonFeature : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "Feature"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonFeature), for: .touchUpInside)
            return button
        }()
        
        let buttonSendImage : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "Next"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonSendImage), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(buttonPhotoLibrary)
        view.addSubview(buttonFeature)
        view.addSubview(buttonSendImage)
        buttonPhotoLibrary.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 20, width: 28, height: 20)
        buttonFeature.anchor(top: view.topAnchor, left: buttonPhotoLibrary.rightAnchor, paddingLeft: 14, width: 30, height: 30)
        buttonSendImage.anchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 12, width: 12, height: 24)
        
        buttonPhotoLibrary.centerY(inView: view)
        buttonFeature.centerY(inView: view)
        buttonSendImage.centerY(inView: view)
        
        return view
    }()
    
    let undoRedoPlayView : UIView = {
        let view = UIView()
        let buttonUndo : UIButton = {
           let button = UIButton()
           button.setImage(#imageLiteral(resourceName: "Undo"), for: .normal)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.addTarget(self, action: #selector(tapbuttonUndo), for: .touchUpInside)
           return button
       }()
        
       let buttonRedo : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "Redo"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonRedo), for: .touchUpInside)
            return button
        }()
        
        let layerButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "layer").withRenderingMode(.alwaysOriginal), for: .normal)
            button.setDimensions(width: 26, height: 26)
            button.addTarget(self, action: #selector(handleShowLayer), for: .touchUpInside)
            
            return button
        }()
        
        let buttonPlay : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonPlay), for: .touchUpInside)
            button.setDimensions(width: 30, height: 26)
            return button
        }()
        
        view.addSubview(buttonUndo)
        view.addSubview(buttonRedo)
        view.addSubview(buttonPlay)
        view.addSubview(layerButton)
        
        buttonUndo.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 20, width: 30, height: 20)
        buttonRedo.anchor(top: view.topAnchor, left: buttonUndo.rightAnchor, paddingLeft: 14, width: 30, height: 20)
        buttonPlay.anchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 14)
        layerButton.anchor(top: view.topAnchor, right: buttonPlay.leftAnchor, paddingRight: 10)
        
        buttonUndo.centerY(inView: view)
        buttonRedo.centerY(inView: view)
        buttonPlay.centerY(inView: view)
        layerButton.centerY(inView: view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        // Do any additional setup after loading the view.
        configureRegister()
    }
    
    //MARK: - Selecotrs
    @objc func tapbuttonPhotoLibrary() {
        print("Tapped PhotoLibrary Button...")
//        dismiss(animated: true, completion: nil)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AddArtworkController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
//        self.dismiss(animated: true) {
//            guard let proto = self.customProtocol else {return}
//            proto.dismissed()
//        }
    }
    
    @objc func tapbuttonFeature() {
        print("Tapped Feature Button...")
    }
    
    @objc func tapbuttonSendImage() {
        print("Tapped Send Button...")
    }
    
    @objc func tapbuttonUndo() {
        print("Tapped Undo Button...")
    }
    
    @objc func tapbuttonRedo() {
        print("Tapped Redo Button...")
    }
    
    @objc func tapbuttonPlay() {
        print("Tapped Play   Button...")
    }
    
    @objc func handleShowLayer() {
        isSelected.toggle()
        if isSelected {
            UIView.animate(withDuration: 0.4) {
                self.layerStackView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.layerStackView.alpha = 0
                self.animateToolBarView.alpha = 0
                self.featureToolBarView.alpha = 1
            }
        }
    }
    
    @objc func handleDeleteLayerItem() {
        print("DEBUG: Delete layer item..")
    }
    
 
    //MARK: - Helpers
    func SolveWidthStackView(_ number : Int) -> CGFloat {
        let result = (screenWidth - CGFloat(12 * 2 + (number - 1) * 8))
        return result/CGFloat(number)
    }
    
    func configureRegister() {
        view.addSubview(featureToolBarView)
        featureToolBarView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        featureToolBarView.alpha = 1
        
        view.addSubview(animateToolBarView)
        animateToolBarView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 100)
        featureToolBarView.delegate = self
        animateToolBarView.delegate = self
        animateToolBarView.alpha = 0
        

        view.addSubview(settingView)
        settingView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 40)
        
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.anchor(left: view.leftAnchor, right: view.rightAnchor, height: screenWidth)
        
        view.addSubview(undoRedoPlayView)
        undoRedoPlayView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, height: 38)
        
        view.addSubview(layerStackView)
        layerStackView.anchor(left: view.leftAnchor, bottom: imageView.bottomAnchor, right: view.rightAnchor, paddingLeft: 12, paddingBottom: 10, paddingRight: 12, height: 56)
        
    }
}

//MARK: - UICollectionViewDataSource
extension AnimateController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LayerCell
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension AnimateController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4) {
            self.featureToolBarView.alpha = 0
            self.animateToolBarView.alpha = 1
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AnimateController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 36, height: 36)
    }
}


//MARK: - ToolBarViewDelegate
extension AnimateController: ToolBarViewDelegate {
    func changeToolBarView(_ animateIsHiden: Bool) {
        if animateIsHiden {
            animateToolBarView.isHidden = true
            featureToolBarView.isHidden = false
        } else {
            animateToolBarView.isHidden = false
            featureToolBarView.isHidden = true
        }
    }
}

