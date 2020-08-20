//
//  Artwork.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/15.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation
import Firebase

struct Artwork {
    var artworkImageUrl: URL?
    let name: String
    let introduction: String
    var timestamp: Date!
    
    var user: User
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        
        self.name = dictionary["name"] as? String ?? ""
        self.introduction = dictionary["introduction"] as? String ?? ""
        
        if let artworkImageUrlString = dictionary["artworkImageUrl"] as? String {
            guard let url = URL(string: artworkImageUrlString) else { return }
            self.artworkImageUrl = url
        }
        
        if let timestamp = dictionary["timeStamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
