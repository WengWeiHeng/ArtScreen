//
//  ProfileViewModel.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/27.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

struct ProfileViewModel {
    private let user: User
    
    var buttonTitle: String {
        if user.isCurrentUser {
            return "Edit"
        } else {
            return "Follow"
        }
    }
    
    var fullnameText: String {
        return user.fullname
    }
    
    var usernameText: String {
        return "@" + user.username
    }
    
    init(user: User) {
        self.user = user
    }
}
