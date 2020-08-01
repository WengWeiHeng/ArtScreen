//
//  AnimateController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class AnimateController: UIViewController {
    
    //MARK: - Properties
    var customProtocol: CustomProtocol?
    var buttonsAnimate : [UIButton] = []
    var buttonsFeature : [UIButton] = []
    
    let stackViewFeature : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.backgroundColor = .white
        return stack
    }()
    
    let stackViewAnimate : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.backgroundColor = .white
        stack.isHidden = true
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
        
        let buttonPlay : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonPlay), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(buttonUndo)
        view.addSubview(buttonRedo)
        view.addSubview(buttonPlay)
        buttonUndo.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 20, width: 30, height: 20)
        buttonRedo.anchor(top: view.topAnchor, left: buttonUndo.rightAnchor, paddingLeft: 14, width: 30, height: 20)
        buttonPlay.anchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 12, width: 50, height: 38)
        
        buttonUndo.centerY(inView: view)
        buttonRedo.centerY(inView: view)
        buttonPlay.centerY(inView: view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        // Do any additional setup after loading the view.
//        scrollViewFeature.delegate = self
//        view.backgroundColor = .black
        configureRegister()
    }
    
    //MARK: - Selecotrs
    @objc func tapbuttonPhotoLibrary() {
        print("Tapped PhotoLibrary Button...")
//        dismiss(animated: true, completion: nil)
        self.dismiss(animated: true) {
            guard let proto = self.customProtocol else {return}
            proto.dismissed()
        }
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
    
    @objc func HandleTapFeature(_ sender : UIButton) {
        print("Tapped Feature ...")
        switch sender.tag {
        case 0:
            print("Tapped \(sender.tag)")
            stackViewFeature.isHidden = true
            stackViewAnimate.isHidden = false
        case 1:
            print("Tapped \(sender.tag)")
        case 2:
            print("Tapped \(sender.tag)")
        case 3:
            print("Tapped \(sender.tag)")
        case 4:
            print("Tapped \(sender.tag)")
        case 5:
            print("Tapped \(sender.tag)")
        default:
            print("Finish")
        }
    }
    
    @objc func HandleTapAnimate(_ sender : UIButton) {
        print("Tapped AnimateFeature...")
        switch sender.tag {
        case 0:
            print("Tapped \(sender.tag)")
            stackViewFeature.isHidden = false
            stackViewAnimate.isHidden = true
        case 1:
            print("Tapped \(sender.tag)")
        case 2:
            print("Tapped \(sender.tag)")
        case 3:
            print("Tapped \(sender.tag)")
        case 4:
            print("Tapped \(sender.tag)")
        default:
            print("Finish")
        }
    }
    
    //MARK: - Helpers
    func SolveWidthStackView(_ number : Int) -> CGFloat {
        let result = (screenWidth - CGFloat(12 * 2 + (number - 1) * 8))
        return result/CGFloat(number)
    }
    
    func configureRegister() {
        let buttonAnimateName = ["Cancel","Path","Anchor","Speed","Delete"]
        let buttonFeatureName = ["Animate","BackDrop","Cover","Adjustment","3DObject","Effects"]
        for i in 0..<buttonFeatureName.count {
            let button = UIButton()
            let sizeHeightWidth = SolveWidthStackView(buttonFeatureName.count)
            button.setDimensions(width: sizeHeightWidth, height: sizeHeightWidth)
            button.setImage(UIImage(named: buttonFeatureName[i]), for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(HandleTapFeature(_:)), for: .touchUpInside)
            buttonsFeature.append(button)
            stackViewFeature.addArrangedSubview(button)
        }
         
        for i in 0..<buttonAnimateName.count {
            let button = UIButton()
            let sizeHeightWidth = SolveWidthStackView(buttonFeatureName.count)
            button.setDimensions(width: sizeHeightWidth, height: sizeHeightWidth)
            button.setImage(UIImage(named: buttonAnimateName[i]), for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(HandleTapAnimate(_:)), for: .touchUpInside)
            buttonsAnimate.append(button)
            stackViewAnimate.addArrangedSubview(button)
        }
        
        view.addSubview(stackViewFeature)
        stackViewFeature.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 12, paddingBottom: 30, paddingRight: 12, width: SolveWidthStackView(6) * 6 + 8 * 5, height: SolveWidthStackView(6))
        
        view.addSubview(stackViewAnimate)
        stackViewAnimate.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 12, paddingBottom: 30, paddingRight: 12, width: SolveWidthStackView(6) * 5 + 8 * 4, height: SolveWidthStackView(6))
        
        view.addSubview(settingView)
        settingView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 40)
        
        view.addSubview(undoRedoPlayView)
        undoRedoPlayView.anchor(left: view.leftAnchor, bottom: stackViewAnimate.topAnchor, right: view.rightAnchor, paddingBottom: 24, height: 38)
        
        view.addSubview(imageView)
        imageView.anchor(top: settingView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, height: screenWidth)
    }
}

