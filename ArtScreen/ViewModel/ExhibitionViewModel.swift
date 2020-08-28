//
//  ExhibitionViewModel.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/22.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

struct ExhibitionViewModel {
    let exhibition: Exhibition
    let user: User
    
    var profileImageUrl: URL? {
        return exhibition.user.profileImageUrl
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    init(exhibition: Exhibition) {
        self.exhibition = exhibition
        self.user = exhibition.user
    }
}
