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
    static func uploadExhibition(credentials: ExhibitionCredentials, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let name = credentials.name
        let introduction = credentials.introduction
        let online = credentials.online
        
        guard let imageData = credentials.exhibitionImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("exhibition-images")
        let ref = storageRef.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion!(error)
                return
            }
            ref.downloadURL { (url, error) in
                guard let exhibitionImageUrl = url?.absoluteString else { return }

                let data = ["uid": uid,
                            "name": name,
                            "introduction": introduction,
                            "exhibitionImageUrl": exhibitionImageUrl,
                            "online": online,
                            "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
                
//                COLLECTION_EXHIBITIONS.addDocument(data: data, completion: completion)
                COLLECTION_EXHIBITIONS.document(uid).collection("user-exhibitions").addDocument(data: data, completion: completion)
            }
        }
    }
    
    static func fetchExhibitions(forUser user: User, completion: @escaping([Exhibition]) -> Void) {
        var exhibitions = [Exhibition]()
        let query = COLLECTION_EXHIBITIONS.document(user.uid).collection("user-exhibitions")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let exhibition = Exhibition(user: user, dictionary: dictionary)
                exhibitions.append(exhibition)
                completion(exhibitions)
            })
        }
    }
//    
//    static func fetchExhibition(withExhibitionID exhibitionID: String, completion: @escaping(Exhibition) -> Void) {
//        COLLECTION_EXHIBITIONS.document(exhibitionID).getDocument { (snapshot, error) in
//            guard let dictionary = snapshot?.data() else { return }
//            guard let uid = dictionary["uid"] as? String else { return }
//            
//            UserService.fetchUser(withUid: uid) { user in
//                let exhibition = Exhibition(user: user, exhibitionID: exhibitionID, dictionary: dictionary)
//                completion(exhibition)
//            }
//        }
//    }
}

