//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 5/23/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import MapKit
import UIKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var noImagesLabel: UILabel!
    
    // MARK: Other Variables
    var dataController: DataController!
    var loadedMap: Map!
    var selectedPin: Pin!
    // TODO: Switch below to actually store images
    var images: LocationAlbum!
    
    // MARK: View Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.delegate = self
        // Carry over map details
        let pinForMap = MKPointAnnotation()
        pinForMap.coordinate = CLLocationCoordinate2DMake(selectedPin.latitude, selectedPin.longitude)
        self.mapView.addAnnotation(pinForMap)
        // Set region of mini-map, dividing latitude span by 4 to be closer to original zoom
        self.mapView.region = MKCoordinateRegion(center: pinForMap.coordinate, span: MKCoordinateSpan(latitudeDelta: loadedMap.spanLatitude / 4, longitudeDelta: loadedMap.spanLongitude))
        // TODO: Change below logic if images in location already obtained
        // Get photos at the current location
        APIClient.getPhotosByLocations(latitude: selectedPin.latitude, longitude: selectedPin.longitude, completion: handlePhotoData(response:error:))
        // TODO: Go load the images themselves
    }
    
    // MARK: Map View Functions
    // Below function based on Udacity PinSample code - pin style
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
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
            if images.photo.count == 0 {
                noImagesLabel.isHidden = false
            }
        }
    }
    
    // MARK: IBActions
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        // TODO: Implement logic to load a new collection
    }
}
