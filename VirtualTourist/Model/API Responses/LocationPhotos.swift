//
//  LocationPhotos.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 6/21/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import Foundation

struct LocationPhotos: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: Int
    let farm: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
    }
}
