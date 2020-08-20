//
//  ArtworkService.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/15.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation
import Firebase

struct ArtworkCredentials {
    let name: String
    let introduction: String
    let artworkImage: UIImage
}

struct ArtworkItemCredentials {
    let artworkItemImage: UIImage
//    let movePath: UIBezierPath
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

struct ArtworkService {
    static func uploadArtwork(credentials: ArtworkCredentials, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let name = credentials.name
        let introduction = credentials.introduction
        
        guard let imageData = credentials.artworkImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("artwork_images")
        let ref = storageRef.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion!(error)
                return
            }
            ref.downloadURL { (url, error) in
                guard let artworkImageUrl = url?.absoluteString else { return }

                let data = ["uid": uid,
                            "name": name,
                            "introduction": introduction,
                            "artworkImageUrl": artworkImageUrl,
                            "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
                
                COLLECTION_ARTWORKS.document(uid).collection("user-artworks").addDocument(data: data, completion: completion)
            }
        }
    }
    
    static func uploadAnimateItemData(credentials: ArtworkItemCredentials, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let artworkID = COLLECTION_ARTWORKS.document(uid).collection("user-artworks").document().documentID
//        print("DEBUG: ArtworkID: \(artworkID)")
//        let movePath = credentials.movePath
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
        
        guard let itemImageData = credentials.artworkItemImage.jpegData(compressionQuality: 0.3) else { return }
        let itemFilename = NSUUID().uuidString
        let itemStorageRef = Storage.storage().reference().child("artwork_images").child("artwork_item_images")
        let itemRef = itemStorageRef.child(itemFilename)
        
        itemRef.putData(itemImageData, metadata: nil) { (meta, error) in
            
            itemRef.downloadURL { (url, error) in
                guard let artworkItemImageUrl = url?.absoluteString else { return }
                
                
                let data = ["artworkItemImage": artworkItemImageUrl,
//                            "movePath": movePath,
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
                
                COLLECTION_ARTWORKS.document(uid).collection("artwork-items").addDocument(data: data, completion: completion)
            }
        }
    }
    
    static func fetchArtworks(forUser user: User, completion: @escaping([Artwork]) -> Void) {
        var artworks = [Artwork]()
        let query = COLLECTION_ARTWORKS.document(user.uid).collection("user-artworks")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let artwork = Artwork(user: user, dictionary: dictionary)
                artworks.append(artwork)
                completion(artworks)
            })
        }
    }
}
