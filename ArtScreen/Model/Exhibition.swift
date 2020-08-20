//
//  Exhibition.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/18.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation

struct Exhibition {
//    let exhibitionID: String
    let name: String
    let introduction: String
    var exhibitionImageUrl: URL?
    var user: User
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        
        self.name = dictionary["name"] as? String ?? ""
        self.introduction = dictionary["introduction"] as? String ?? ""
        
        if let exhibitionImageUrlString = dictionary["exhibitionImageUrl"] as? String {
            guard let url = URL(string: exhibitionImageUrlString) else { return }
            self.exhibitionImageUrl = url
        }
    }
    
}
