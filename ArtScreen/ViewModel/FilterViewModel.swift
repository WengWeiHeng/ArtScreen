//
//  FilterViewModel.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/20.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

enum FilterOptions: Int, CaseIterable {
    case exhibitions
    case artworks
    
    var description: String {
        switch self {
        case .exhibitions: return "EXHIBITION"
        case .artworks: return "ARTWORK"
        }
    }
}

enum SearchOptions: Int, CaseIterable {
    case all
    case artist
    case artwork
    case exhibition
    case place
    
    var description: String {
        switch self {
        case .all: return "All"
        case .artist: return "Artist"
        case .artwork: return "Artwork"
        case .exhibition: return "Exhibition"
        case .place: return "Place"
        }
    }
}

struct FilterViewModel {
    
}
