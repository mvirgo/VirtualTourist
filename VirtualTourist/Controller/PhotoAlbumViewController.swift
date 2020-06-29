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
    var imagesDownload: LocationAlbum!
    var savedPhotos = [Photo]()
    
    // MARK: View Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMap()
        if selectedPin.photos?.count == 0 {
            // Get photos at the current location
            getPhotosFromFlickr()
        } else {
            // TODO: Get photos from Core Data
        }
        // TODO: Show photos in collection view
    }
    
    // MARK: Map View Functions
    func setMap() {
        mapView.delegate = self
        // Carry over map details
        let pinForMap = MKPointAnnotation()
        pinForMap.coordinate = CLLocationCoordinate2DMake(selectedPin.latitude, selectedPin.longitude)
        self.mapView.addAnnotation(pinForMap)
        // Set region of mini-map, dividing latitude span by 4 to be closer to original zoom
        self.mapView.region = MKCoordinateRegion(center: pinForMap.coordinate, span: MKCoordinateSpan(latitudeDelta: loadedMap.spanLatitude / 4, longitudeDelta: loadedMap.spanLongitude))
    }
    
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
    
    // MARK: API Calls
    func getPhotosFromFlickr() {
        APIClient.getPhotosByLocations(latitude: selectedPin.latitude, longitude: selectedPin.longitude, completion: handlePhotoData(response:error:))
    }
    
    // MARK: Completion Handlers
    func handlePhotoData(response: LocationAlbum?, error: Error?) {
        if let _ = error {
            let alertVC = UIAlertController(title: "Download Failed", message: "Failed to download location photos.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.present(alertVC, animated: true, completion: nil)
        } else {
            imagesDownload = response!
            if imagesDownload.photo.count == 0 {
                noImagesLabel.isHidden = false
            }
            // Load the images themselves
            for photoData in imagesDownload.photo {
                let photoURL = "https://farm\(photoData.farm).staticflickr.com/\(photoData.server)/\(photoData.id)_\(photoData.secret).jpg"
                // Get the actual photo
                APIClient.downloadImage(imageURLString: photoURL, completion: handleSinglePhoto(photoData:error:))
            }
        }
    }
    
    func handleSinglePhoto(photoData: Data?, error: Error?) {
        if let _ = error {
            // TODO: Do something about error
        } else {
            // Store the photo in Core Data
            let newPhoto = Photo(context: dataController.viewContext)
            newPhoto.image = photoData
            newPhoto.pin = selectedPin
            saveData()
            // TODO: Add to savedPhotos or show in collection view?
        }
    }
    
    // MARK: Other functions
    func saveData() {
        // Save the view context
        do {
            try dataController.viewContext.save()
        } catch {
            print("Failed to save photo.")
        }
    }
    
    // MARK: IBActions
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        // TODO: Implement logic to load a new collection, and delete old one
    }
}
