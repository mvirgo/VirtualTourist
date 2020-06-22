//
//  ErrorResponse.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 6/21/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let code: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return "\(code): \(message)"
    }
}
