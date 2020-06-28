//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 5/23/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import MapKit
import UIKit

class PhotoAlbumViewController: UIViewController {
    
    // MARK: Other Variables
    var dataController: DataController!
    var selectedCoordinate: CLLocationCoordinate2D!
    // TODO: Switch below to actually store images
    var images: LocationAlbum!
    
    // MARK: View Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Get photos at the current location
        APIClient.getPhotosByLocations(latitude: selectedCoordinate.latitude, longitude: selectedCoordinate.longitude, completion: handlePhotoData(response:error:))
        // TODO: Go load the images themselves
    }
    
    // MARK: Completion Handlers
    func handlePhotoData(response: LocationAlbum?, error: Error?) {
        if let _ = error {
            let alertVC = UIAlertController(title: "Download Failed", message: "Failed to download location photos.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.present(alertVC, animated: true, completion: nil)
        } else {
            // TODO: Update this based on what to do with images
            images = response!
        }
    }
}
