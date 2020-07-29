//
//  User.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/20.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var profileImageUrl: URL?
    let username: String
    let fullname: String
    let email: String
    let uid: String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String{
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}
