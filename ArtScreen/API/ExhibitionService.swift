//
//  ExhibitionService.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/18.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation
import Firebase

struct ExhibitionCredentials {
    let name: String
    let introduction: String
    let exhibitionImage: UIImage
    let online: Bool
}

struct ExhibitionService {
    static func uploadExhibition(credentials: ExhibitionCredentials, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let name = credentials.name
        let introduction = credentials.introduction
        let online = credentials.online
        
        guard let imageData = credentials.exhibitionImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("exhibition-images")
        let ref = storageRef.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let exhibitionImageUrl = url?.absoluteString else { return }

                let data = ["uid": uid,
                            "name": name,
                            "introduction": introduction,
                            "exhibitionImageUrl": exhibitionImageUrl,
                            "online": online,
                            "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
                
                REF_EXHIBITIONS.childByAutoId().updateChildValues(data) { (err, ref) in
                    guard let exhibitionID = ref.key else { return }
                    REF_USER_EXHIBITIONS.child(uid).child(exhibitionID).updateChildValues([exhibitionID: 1], withCompletionBlock: completion)
                }

            }
        }
    }
    
    static func fetchExhibitions(completion: @escaping([Exhibition]) -> Void) {
        var exhibitions = [Exhibition]()
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_EXHIBITIONS.observe(.childAdded) { snapshot in
            let exhibitionID = snapshot.key
            self.fetchExhibition(withExhibitionID: exhibitionID) { exhibition in
                exhibitions.append(exhibition)
                completion(exhibitions)
            }
        }
    }
    
    static func fetchUserExhibitions(forUser user: User, completion: @escaping([Exhibition]) -> Void) {
        var exhibitions = [Exhibition]()
        REF_USER_EXHIBITIONS.child(user.uid).observe(.childAdded) { (snapshot) in
            let exhibitionID = snapshot.key
            
            self.fetchExhibition(withExhibitionID: exhibitionID) { exhibition in
                exhibitions.append(exhibition)
                completion(exhibitions)
            }
        }
    }
    
    static func fetchExhibition(withExhibitionID exhibitionID: String, completion: @escaping(Exhibition) -> Void) {
        REF_EXHIBITIONS.child(exhibitionID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }

            UserService.fetchUser(withUid: uid) { (user) in
                let exhibition = Exhibition(user: user, exhibitionID: exhibitionID, dictionary: dictionary)
                completion(exhibition)
            }
        }
    }
    
    static func fetchExhibitionArtwork(withExhibitionID exhibitionID: String, completion: @escaping([Artwork]) -> Void) {
        var artworks = [Artwork]()
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        self.fetchExhibition(withExhibitionID: exhibitionID) { exhibition in
            REF_EXHIBITIONS.child(exhibition.exhibitionID).observe(.childAdded) { (snapshot) in
                print("DEBUG: snapshot: \(snapshot.key)")
                let artworkID = snapshot.key                
                ArtworkService.fetchArtwork(withArtworkID: artworkID) { (artwork) in
                    artworks.append(artwork)
                    completion(artworks)
                }
            }
        }
    }
}


