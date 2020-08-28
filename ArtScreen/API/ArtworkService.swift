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
    let width: Float
    let height: Float
}

struct ArtworkService {
    static func uploadAnimateArtwork(credentials: ArtworkCredentials, itemCredentials: ArtworkItemCredentials, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let name = credentials.name
        let introduction = credentials.introduction
        let width = credentials.width
        let height = credentials.height
        
        guard let imageData = credentials.artworkImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("artwork_images")
        let ref = storageRef.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let artworkImageUrl = url?.absoluteString else { return }

                let data = ["uid": uid,
                            "name": name,
                            "introduction": introduction,
                            "artworkImageUrl": artworkImageUrl,
                            "width": width,
                            "height": height,
                            "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
                
                REF_ARTWORKS.childByAutoId().updateChildValues(data) { (err, ref) in
                    guard let artworkID = ref.key else { return }
                    ArtworkItemService.uploadAnimateItemData(credentials: itemCredentials) { (err, ref) in
                        guard let itemID = ref.key else { return }
                        ArtworkItemService.fetchArtworkItem(withArtworkID: artworkID, itemID: itemID) { (err, ref) in
                            REF_USER_ARTWORKS.child(uid).updateChildValues([artworkID: 1], withCompletionBlock: completion)
                        }
                    }
                }
            }
        }
    }
    
    static func uploadArtwork(credentials: ArtworkCredentials, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let name = credentials.name
        let introduction = credentials.introduction
        
        guard let imageData = credentials.artworkImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("artwork_images")
        let ref = storageRef.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let artworkImageUrl = url?.absoluteString else { return }

                let data = ["uid": uid,
                            "name": name,
                            "introduction": introduction,
                            "artworkImageUrl": artworkImageUrl,
                            "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
                
                REF_ARTWORKS.childByAutoId().updateChildValues(data) { (err, ref) in
                    guard let artworkID = ref.key else { return }
                    REF_USER_ARTWORKS.child(uid).updateChildValues([artworkID: 1], withCompletionBlock: completion)
                }
            }
        }
    }
    
    static func fetchUserArtworks(forUser user: User, completion: @escaping([Artwork]) -> Void) {
        var artworks = [Artwork]()
        REF_USER_ARTWORKS.child(user.uid).observe(.childAdded) { (snapshot) in
            let artworkID = snapshot.key
            
            self.fetchArtwork(withArtworkID: artworkID) { artwork in
                artworks.append(artwork)
                completion(artworks)
            }
        }
    }
    
    static func fetchArtwork(withArtworkID artworkID: String, completion: @escaping(Artwork) -> Void) {
        REF_ARTWORKS.child(artworkID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.fetchUser(withUid: uid) { (user) in
                let artwork = Artwork(user: user, artworkID: artworkID, dictionary: dictionary)
                completion(artwork)
            }
        }
    }
    
    static func addArtworkInExhibition(withExhibitionID exhibitionID: String, artwork: Artwork, completion: @escaping(DatabaseCompletion)) {

        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_EXHIBITIONS.child(exhibitionID).updateChildValues([artwork.artworkID: 1]) { (error, ref) in
            REF_USER_EXHIBITIONS.child(uid).child(exhibitionID).updateChildValues([artwork.artworkID: 1], withCompletionBlock: completion)
        }
    }
    
    static func getArtworkImageUrl(completion: @escaping([Artwork]) -> Void) {
        var artworks = [Artwork]()
        
        REF_ARTWORKS.observe(.childAdded) { (snapshot) in
            let artworkID = snapshot.key
            self.fetchArtwork(withArtworkID: artworkID) { (artwork) in
                artworks.append(artwork)
                completion(artworks)
            }
        }
    }
}
