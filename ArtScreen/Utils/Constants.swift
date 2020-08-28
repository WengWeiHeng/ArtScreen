//
//  Constants.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/20.
//  Copyright © 2020 Heng. All rights reserved.
//

import Firebase

let STROAGE_EXHIBITIONS_IMAGES = Storage.storage().reference().child("exhibition-images")
let STORAGE_ARTWORK_IMAGES = Storage.storage().reference().child("artwork_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let REF_EXHIBITIONS = DB_REF.child("exhibitions")
let REF_USER_EXHIBITIONS = DB_REF.child("user-exhibitions")

let REF_ARTWORKS = DB_REF.child("artworks")
let REF_USER_ARTWORKS = DB_REF.child("user-artworks")
let REF_EXHIBITION_ARTWORKS = DB_REF.child("exhibition-artworks")

let REF_ARTWORKITEMS = DB_REF.child("artworkItems")
let REF_ARTWORK_ARTWORKITEMS = DB_REF.child("artwork-artworksItems")


//let REF_ANIMATIONS = DB_REF.child("animations")
//let REF_ARTWORK_ANIMATIONS = DB_REF.child("artwork-animations")
