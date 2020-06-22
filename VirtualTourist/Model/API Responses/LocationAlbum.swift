//
//  LocationAlbum.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 6/21/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import Foundation

struct LocationAlbum: Codable {
    let photo: [LocationPhotos]
    let page: Int
    let pages: Int
    let perpage: Int
    
    enum CodingKeys: String, CodingKey {
        case photo
        case page
        case pages
        case perpage
    }
}
