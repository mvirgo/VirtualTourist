//
//  PhotoSearchRequest.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 6/21/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import Foundation

struct PhotoSearchRequest: Codable {
    let method: String
    let apiKey: String
    let accuracy: Int
    let lat: Double
    let lon: Double
    let format: String
    
    enum CodingKeys: String, CodingKey {
        case method
        case apiKey = "api_key"
        case accuracy
        case lat
        case lon
        case format
    }
}
