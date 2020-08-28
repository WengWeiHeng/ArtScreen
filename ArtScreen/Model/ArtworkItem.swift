//
//  ArtworkItem.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/16.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation

struct ArtworkItem {
    var artworkItemImageUrl: URL?
    
    let width: Float
    let height: Float
    let x: Float
    let y: Float
    
    let emitterSize: Float
    let emitterSpeed: Float
    let emitterRedValue: Float
    let emitterGreenValue: Float
    let emitterBlueValue: Float
    
    let moveAnimateSpeed: Float
    
    let rotateFromValue: Float
    let rotateToValue: Float
    let rotateAnimateSpeed: CFTimeInterval
    
    let scaleFromValue: Float
    let scaleToValue: Float
    let scaleAnimateSpeed: CFTimeInterval
    
    let opacityFromValue: Float
    let opacityToValue: Float
    let opacityAnimateSpeed: CFTimeInterval
    
//    var artwork: Artwork
    var artworkItemId: String
    
    init(artworkItemId: String, dictionary: [String: Any]) {
//        self.artwork = artwork
        self.artworkItemId = artworkItemId
        
        self.width = dictionary["width"] as? Float ?? 0
        self.height = dictionary["height"] as? Float ?? 0
        self.x = dictionary["x"] as? Float ?? 0
        self.y = dictionary["y"] as? Float ?? 0
        
        self.emitterSize = dictionary["emitterSize"] as? Float ?? 0
        self.emitterSpeed = dictionary["emitterSpeed"] as? Float ?? 0
        self.emitterRedValue = dictionary["emitterRedValue"] as? Float ?? 0
        self.emitterGreenValue = dictionary["emitterGreenValue"] as? Float ?? 0
        self.emitterBlueValue = dictionary["emitterBlueValue"] as? Float ?? 0
        
        self.moveAnimateSpeed = dictionary["moveAnimateSpeed"] as? Float ?? 0
        
        self.rotateFromValue = dictionary["rotateFromValue"] as? Float ?? 0
        self.rotateToValue = dictionary["rotateToValue"] as? Float ?? 0
        self.rotateAnimateSpeed = dictionary["rotateAnimateSpeed"] as? Double ?? 0
        
        self.scaleFromValue = dictionary["scaleFromValue"] as? Float ?? 0
        self.scaleToValue = dictionary["scaleToValue"] as? Float ?? 0
        self.scaleAnimateSpeed = dictionary["scaleAnimateSpeed"] as? Double ?? 0
        
        self.opacityFromValue = dictionary["opacityFromValue"] as? Float ?? 0
        self.opacityToValue = dictionary["opacityToValue"] as? Float ?? 0
        self.opacityAnimateSpeed = dictionary["opacityAnimateSpeed"] as? Double ?? 0
        
        
        if let artworkItemImageUrlString = dictionary["artworkItemImage"] as? String {
            guard let url = URL(string: artworkItemImageUrlString) else { return }
            self.artworkItemImageUrl = url
        }
    }
}
