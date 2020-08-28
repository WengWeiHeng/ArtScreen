//
//  ARCameraController.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/8.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import ARKit
import Firebase

class ARCameraController: UIViewController {
    
    //MARK: - Properties
    private var sceneView = ARSCNView()
    let configuration = ARImageTrackingConfiguration()
    let updateQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).serialSCNQueue")
    
    var artworkImages = [UIImage]()
    var artworks = [Artwork]()
    var artwork: Artwork?
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"Cancel"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSceneView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Add Images
        loadingStorageUrl()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func loadingStorageUrl() {
        ArtworkService.getArtworkImageUrl { (artworks) in
            self.artworks = artworks
                let url = try? URL(resolvingAliasFileAt: artworks[artworks.count - 1].artworkImageUrl!)
                let data = try? Data(contentsOf: url!)
                print("url = \(url)")
                print("data = \(data)")
                DispatchQueue.main.async {
                    self.artworkImages.append(UIImage(data: data!)!)
                    self.configuration.trackingImages = self.loadedImagesFromDirectoryContents(self.artworkImages)
                    print("DEBUG: artworksImages.count \(self.artworkImages.count)")
                    self.sceneView.session.run(self.configuration)
                }
        }
    }
    
    func configureSceneView() {
        view.addSubview(sceneView)
        sceneView.addConstraintsToFillView(view)
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        
//        view.addSubview(closeButton)
//        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 12)
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
         return cgImage
        }
        return nil
    }
    
    func loadDynamicImageReferences(_ str : String){
        guard let imageFromBundle = UIImage(named: str),
        let imageToCIImage = CIImage(image: imageFromBundle),
        let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage)else { return }
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
        arImage.name = str
        configuration.trackingImages = [arImage]
    }
    
    func loadDynamicImageReferences(_ image : UIImage){
        guard let imageToCIImage = CIImage(image: image),
        let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage)else { return }
        let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
//        arImage.name = str
        configuration.trackingImages = [arImage]
    }
    
    func loadedImagesFromDirectoryContents(_ images: [UIImage]) -> Set<ARReferenceImage>{
        var index = 0
        var customReferenceSet = Set<ARReferenceImage>()
        images.forEach { (image) in
            guard let imageToCIImage = CIImage(image: image),
            let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage)else { return }
            let arImage = ARReferenceImage(cgImage, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.2)
            arImage.name = "MyCustomARImage\(index)"
            //4. Insert The Reference Image Into Our Set
            customReferenceSet.insert(arImage)
//            print("ARReference Image == \(arImage)")
            index += 1
        }
        return customReferenceSet

    }
    
    //MARK: - Image height light
    func highlightDetection(on rootNode: SCNNode, width: CGFloat, height: CGFloat, completionHandler block: @escaping (() -> Void)) {
        let planeNode = SCNNode(geometry: SCNPlane(width: width, height: height))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.mainDarkGray
        planeNode.opacity = 0
        
        rootNode.addChildNode(planeNode)
        planeNode.runAction(self.imageHighlightAction) {
            block()
        }
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
}

extension ARCameraController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        updateQueue.async {
            let physicalWidth = imageAnchor.referenceImage.physicalSize.width
            let physicalHeight = imageAnchor.referenceImage.physicalSize.height
            let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)
            mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
            
            let mainNode = SCNNode(geometry: mainPlane)
            mainNode.eulerAngles.x = -.pi / 2
            mainNode.renderingOrder = -1
            mainNode.opacity = 1
            
            node.addChildNode(mainNode)
            
            self.highlightDetection(on: mainNode, width: physicalWidth, height: physicalHeight) {
                
                let animatePlane = SCNPlane(width: physicalWidth, height: physicalHeight)
                var index = -1
                for i in 0..<self.artworkImages.count {
                    index += 1
                    let tmp = "MyCustomARImage\(i)"
                    if tmp == imageAnchor.name {
                        break;
                    }
                }
                let controller = ARResultTestController()
                controller.artwork = self.artworks[index]
                animatePlane.firstMaterial?.diffuse.contents = controller.view
    
                let animateNode = SCNNode(geometry: animatePlane)
                animateNode.eulerAngles.x = -.pi / 2
                node.addChildNode(animateNode)
                node.runAction(.sequence([.wait(duration: 3)]))
            }
        }
    }
//
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//        if let imageAnchor = anchor as? ARImageAnchor {
//            // 目的の画像を青い面をかぶせる
//            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
//
//            var index = -1
//             for i in 0..<artworkImages.count {
//                index += 1
//                let tmp = "MyCustomARImage\(i)"
//                if tmp == imageAnchor.name {
//                    break;
//                }
//            }
//            let controller = ARResultTestController()
//            controller.artwork = artworks[index]
//            plane.firstMaterial?.diffuse.contents = controller.view
////            plane.firstMaterial?.diffuse.contents = UIColor.blue.cgColor
//            let planeNode = SCNNode(geometry: plane)
//            planeNode.eulerAngles.x = -.pi / 2
//            node.addChildNode(planeNode)
//        }
//        return node
//    }
}
