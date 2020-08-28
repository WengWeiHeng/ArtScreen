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
    let width: Float
    let height: Float
    let name: String
    let introduction: String
    var timestamp: Date!
    let artworkID: String
    
    var user: User
    
    init(user: User, artworkID: String, dictionary: [String: Any]) {
        self.user = user
        self.artworkID = artworkID
        
        self.name = dictionary["name"] as? String ?? ""
        self.introduction = dictionary["introduction"] as? String ?? ""
        self.width = dictionary["width"] as? Float ?? 0
        self.height = dictionary["height"] as? Float ?? 0
        
        if let artworkImageUrlString = dictionary["artworkImageUrl"] as? String {
            guard let url = URL(string: artworkImageUrlString) else { return }
            self.artworkImageUrl = url
        }
        
        if let timestamp = dictionary["timeStamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
