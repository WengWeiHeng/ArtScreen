//
//  ArtworkItemService.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/24.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation
import Firebase

struct ArtworkItemCredentials {
    let artworkItemImage: UIImage
//    let movePath: UIBezierPath
    let width: Float
    let height: Float
    let x: Float
    let y: Float
    
    let emitterSize: Float
    let emitterSpeed: Float
    let emitterRedValue: Float
    let emitterGreenValue: Float
    let emitterBlueValue: Float
    
    let moveAnimateSpeed: CFTimeInterval
    let rotateFromValue: Float
    let rotateToValue: Float
    let rotateAnimateSpeed: CFTimeInterval
    let scaleFromValue: Float
    let scaleToValue: Float
    let scaleAnimateSpeed: CFTimeInterval
    let opacityFromValue: Float
    let opacityToValue: Float
    let opacityAnimateSpeed: CFTimeInterval
}

struct ArtworkItemService {
        static func uploadAnimateItemData(credentials: ArtworkItemCredentials, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let width = credentials.width
        let height = credentials.height
        let x = credentials.x
        let y = credentials.y
            
        let emitterSize = credentials.emitterSize
        let emitterSpeed = credentials.emitterSpeed
        let emitterRedValue = credentials.emitterRedValue
        let emitterGreenValue = credentials.emitterGreenValue
        let emitterBlueValue = credentials.emitterBlueValue
            
        let moveAnimateSpeed = credentials.moveAnimateSpeed
        let rotateFromValue = credentials.rotateFromValue
        let rotateToValue = credentials.rotateToValue
        let rotateAnimateSpeed = credentials.rotateAnimateSpeed
        let scaleFromValue = credentials.scaleFromValue
        let scaleToValue = credentials.scaleToValue
        let scaleAnimateSpeed = credentials.scaleAnimateSpeed
        let opacityFromValue = credentials.opacityFromValue
        let opacityToValue = credentials.opacityToValue
        let opacityAnimateSpeed = credentials.opacityAnimateSpeed

//        guard let itemImageData = credentials.artworkItemImage.jpegData(compressionQuality: 0.3) else { return }
        guard let itemImageData = credentials.artworkItemImage.pngData() else { return }
        let itemFilename = NSUUID().uuidString
        let itemStorageRef = Storage.storage().reference().child("artwork_images").child("artwork_item_images")
        let itemRef = itemStorageRef.child(itemFilename)

        itemRef.putData(itemImageData, metadata: nil) { (meta, error) in

            itemRef.downloadURL { (url, error) in
                guard let artworkItemImageUrl = url?.absoluteString else { return }


                let data = ["artworkItemImage": artworkItemImageUrl,
                            "width": width,
                            "height": height,
                            "x": x,
                            "y": y,
                            "emitterSize": emitterSize,
                            "emitterSpeed": emitterSpeed,
                            "emitterRedValue": emitterRedValue,
                            "emitterGreenValue": emitterGreenValue,
                            "emitterBlueValue": emitterBlueValue,
//                                "movePath": movePath,
                            "moveAnimateSpeed": moveAnimateSpeed,
                            "rotateFromValue": rotateFromValue,
                            "rotateToValue": rotateToValue,
                            "rotateAnimateSpeed": rotateAnimateSpeed,
                            "scaleFromValue": scaleFromValue,
                            "scaleToValue": scaleToValue,
                            "scaleAnimateSpeed": scaleAnimateSpeed,
                            "opacityFromValue": opacityFromValue,
                            "opacityToValue": opacityToValue,
                            "opacityAnimateSpeed": opacityAnimateSpeed] as [String: Any]
                
                REF_ARTWORKITEMS.childByAutoId().updateChildValues(data, withCompletionBlock: completion)
            }
        }
    }
    
    static func fetchArtworkItem(withArtworkID artworkID: String, itemID: String, completion: @escaping(DatabaseCompletion)) {
        REF_ARTWORKS.child(artworkID).updateChildValues([itemID: 1], withCompletionBlock: completion)
    }
    
    static func fetchArtworkItems(withArtwork artwork: Artwork, completion: @escaping(ArtworkItem) -> Void) {
        REF_ARTWORKS.child(artwork.artworkID).observe(.childAdded) { (snapshot) in
            
            let artworkItemId = snapshot.key
            REF_ARTWORKITEMS.child(artworkItemId).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let artworkItem = ArtworkItem(artworkItemId: artworkItemId, dictionary: dictionary)
                completion(artworkItem)
            }
        }
    }
}
