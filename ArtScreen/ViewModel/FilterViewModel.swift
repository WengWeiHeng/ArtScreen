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

struct FilterViewModel {
    
}
