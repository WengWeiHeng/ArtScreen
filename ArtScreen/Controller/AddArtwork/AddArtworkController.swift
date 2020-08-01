//
//  AddArtworkController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import AVFoundation
let screen = UIScreen.main.bounds
let screenWidth = screen.size.width
let screenHeight = screen.size.height

class AddArtworkController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    private var scrollView : UIScrollView!
    var view1 = CameraView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var view2 = AlbumView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    let buttonCamera : UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.setTitle("CAMERA", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapButtonCamera), for: .touchUpInside)

        return button
    }()
    
    let buttonAlbum : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("ALBUM", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleTapButtonAlbum), for: .touchUpInside)
        
        return button
    }()
    
    let buttonCancel : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapButtonCancel), for: .touchUpInside)
        button.setDimensions(width: 24, height: 24)
        
        return button

    }()
    
    let cameraView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let captureImageView : UIImageView = {
        let img = UIImageView()
        
        return img
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let width = self.view.frame.maxX, height = self.view.frame.maxY
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        configureScrollView()
        setupButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Selectors
    @objc func handleTapButtonAlbum() {
        print("Tap Button Album")
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x +=  self.view.bounds.width
            buttonAlbum.backgroundColor = .purple
            buttonAlbum.setTitleColor(.white, for: .normal)
            buttonCamera.backgroundColor = .white
            buttonCamera.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func handleTapButtonCamera() {
        print("Tap Button Camera")
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x -=  self.view.bounds.width
            buttonCamera.backgroundColor = .purple
            buttonCamera.setTitleColor(.white, for: .normal)
            buttonAlbum.backgroundColor = .white
            buttonAlbum.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func handleTapButtonCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func setupButton() {
        view.addSubview(buttonCamera)
        view.addSubview(buttonAlbum)
        view.addSubview(buttonCancel)
        
        buttonCamera.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 70, paddingBottom: 50, width: 100, height: 30)
        buttonAlbum.anchor(left: buttonCamera.rightAnchor, bottom: view.bottomAnchor, paddingLeft: 15, paddingBottom: 50, width: 100, height: 30)
        buttonCancel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 15)
    }
    
    func configureScrollView() {
        scrollView = UIScrollView(frame: self.view.frame)
        let pageSize = 2
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: CGFloat(pageSize) * screenWidth, height: screenHeight)
        self.view.addSubview(scrollView)

//        view.backgroundColor = .black
//        configureViewCamera()
        scrollView.addSubview(view1)
//        viewCamera.alpha = 0.0
        scrollView.addSubview(view2)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // スクロール数が1ページ分になったら時.
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            // ページの場所を切り替える.
            let page = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
            if page == 0 {
                buttonCamera.backgroundColor = .purple
                buttonCamera.setTitleColor(.white, for: .normal)
                buttonAlbum.backgroundColor = .white
                buttonAlbum.setTitleColor(.black, for: .normal)
            } else {
                buttonAlbum.backgroundColor = .purple
                buttonAlbum.setTitleColor(.white, for: .normal)
                buttonCamera.backgroundColor = .white
                buttonCamera.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    func configureViewCamera() {
        scrollView.addSubview(cameraView)
        cameraView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 70, height: screenWidth)
    }
}
