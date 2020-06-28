//
//  PhotoSearchResponse.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 6/21/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import Foundation

struct PhotoSearchResponse: Codable {
    let photos: LocationAlbum
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
}
