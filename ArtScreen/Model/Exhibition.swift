//
//  Exhibition.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/18.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation

struct Exhibition {
    let exhibitionID: String
    let name: String
    let introduction: String
    var exhibitionImageUrl: URL?
    var timestamp: Date!
    var user: User
    let uid: String
//    var artwork: Artwork
    
    init(user: User, exhibitionID: String, dictionary: [String: Any]) {
        self.user = user
//        self.artwork = artwork
        self.exhibitionID = exhibitionID
        
        self.name = dictionary["name"] as? String ?? ""
        self.introduction = dictionary["introduction"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        if let exhibitionImageUrlString = dictionary["exhibitionImageUrl"] as? String {
            guard let url = URL(string: exhibitionImageUrlString) else { return }
            self.exhibitionImageUrl = url
        }
        
        if let timestamp = dictionary["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
    
}
