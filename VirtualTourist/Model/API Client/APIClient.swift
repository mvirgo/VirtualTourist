//
//  APIClient.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 6/21/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import Foundation

class APIClient {
    // MARK: Struct for authentication and user data
    struct Auth {
        static var apiKey = ""
    }
    
    // MARK: API Endpoints
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest/"
        static let searchPhotosMethod = "flickr.photos.search"
    }
    
    // MARK: General JSON response handling
    // Handle responses or errors for any request type
    class func handleResponseOrError<ResponseType: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: @escaping (ResponseType?, Error?) -> Void) {
        guard let data = data else {
            DispatchQueue.main.async {
                completion(nil, error)
            }
            return
        }
        
        let decoder = JSONDecoder()
        
        do {
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                completion(responseObject, nil)
            }
        } catch {
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(nil, errorResponse)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    // MARK: General Request Types
    // Send GET Requests
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            handleResponseOrError(data, response, error, completion)
        }
        task.resume()
    }
    
    // MARK: Specific API requests
    class func getPhotosByLocations(latitude: Double, longitude: Double, completion: @escaping (LocationAlbum?, Error?) -> Void) {
        let url = URL(string: "\(Endpoints.base)?method=\(Endpoints.searchPhotosMethod)&api_key=\(Auth.apiKey)&accuracy=11&lat=\(latitude)&lon=\(longitude)&format=json&nojsoncallback=1")
        taskForGETRequest(url: url!, responseType: PhotoSearchResponse.self) { response, error in
            if let response = response {
                completion(response.photos, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
