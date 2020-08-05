//
//  FeatureToolBarViewModel.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/5.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation

//MARK: - FeatureToolBarOption
enum FeatureToolBarOption : Int,CaseIterable {
    case anchor
    case cut
    case delete

    var description : String {
        switch self {
        case .anchor: return "Anchor"
        case .cut: return "Cut"
        case .delete: return "Delete"
        
        }
    }
    var iconName : String {
        switch self {
        case .anchor: return "anchor"
        case .cut: return "cut"
        case .delete: return "delete"
        
        }
    }
}

//MARK: - AnimateToolBarOption
enum AnimateToolBarOption : Int,CaseIterable {
    case path
    case rotate
    case flash
    case scale
    
    var description : String {
        switch self {
        case .path: return "Path"
        case .rotate: return "Rotate"
        case .flash: return "Flash"
        case .scale: return "Scale"
        }
    }
    var iconName : String {
        switch self {
        case .path: return "path"
        case .rotate: return "rotate"
        case .flash: return "flashing"
        case .scale: return "scale"
        }
    }
}

//MARK: - DefaultToolBarOption
enum DefaultToolBarOption : Int,CaseIterable {
    case Paint
    case Font
    case Style
    case Color
    case Delete
    var description : String {
        switch self {
        case .Paint: return "Paint"
        case .Font: return "Font"
        case .Style: return "Style"
        case .Color: return "Color"
        case .Delete: return "Delete"
        }
    }
    var iconName : String {
        switch self {
        case .Paint: return "paint"
        case .Font: return "font"
        case .Style: return "style"
        case .Color: return "color"
        case .Delete: return "delete"
        }
    }
}

