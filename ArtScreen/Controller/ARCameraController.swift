//
//  ARCameraController.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/8.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import ARKit

class ARCameraController: UIViewController {
    
    //MARK: - Properties
    private var sceneView = ARSCNView()
    let configuration = ARWorldTrackingConfiguration()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSceneView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Helpers
    func configureSceneView() {
        view.addSubview(sceneView)
        sceneView.addConstraintsToFillView(view)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
    }
}
