//
//  RegistrationViewModel.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/23.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation

struct RegistrationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
