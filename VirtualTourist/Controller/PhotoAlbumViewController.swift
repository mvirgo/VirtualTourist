//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 5/23/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import MapKit
import UIKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var noImagesLabel: UILabel!
    
    // MARK: Other Variables
    var dataController: DataController!
    var loadedMap: Map!
    var selectedPin: Pin!
    var imagesDownload: LocationAlbum!
    var selectedPhoto: Photo!
    var savedPhotos = [Photo]()
    var numberOfPhotos = 0
    
    // MARK: View Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        setMap()
        if selectedPin.photos?.count == 0 {
            // Get photos at the current location
            getPhotosFromFlickr()
        } else if selectedPin.photos?.count != savedPhotos.count {
            // Make sure savedPhotos is clear
            savedPhotos.removeAll()
            // Get photos from Core Data
            let pinPhotos = selectedPin.photos!
            for photo in pinPhotos {
                savedPhotos.append(photo as! Photo)
            }
            numberOfPhotos = savedPhotos.count
            collectionView.reloadData()
        } // Else condition means same photos; don't need to reload
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
    
    // MARK: Collection View Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPhotos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let indexInt = (indexPath as NSIndexPath).row
        
        // Fill image cell if downloaded, or use placeholder
        if indexInt < savedPhotos.count {
            let photo = savedPhotos[indexInt]
            // Set the image in the cell
            if let imageData = photo.image {
                cell.imageCell.image = UIImage(data: imageData)
            }
        } else {
            // Use placeholder image
            cell.imageCell.image = UIImage(named: "placeholder")
        }
        // Show full image in cell
        cell.imageCell.contentMode = .scaleToFill
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the photo from the array and set to selectedPhoto
        selectedPhoto = savedPhotos[(indexPath as NSIndexPath).row]
        // Segue to detail view
        performSegue(withIdentifier: "showPhotoDetail", sender: nil)
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
            numberOfPhotos = imagesDownload.photo.count
            for photoData in imagesDownload.photo {
                let photoURL = "https://farm\(photoData.farm).staticflickr.com/\(photoData.server)/\(photoData.id)_\(photoData.secret).jpg"
                // Get the actual photo
                APIClient.downloadImage(imageURLString: photoURL, completion: handleSinglePhoto(photoData:error:))
            }
        }
    }
    
    func handleSinglePhoto(photoData: Data?, error: Error?) {
        if let _ = error {
            print("Error downloading image, not stored.")
        } else {
            // Store the photo in Core Data
            let newPhoto = Photo(context: dataController.viewContext)
            newPhoto.image = photoData
            newPhoto.pin = selectedPin
            saveData()
            // Add to savedPhotos array
            savedPhotos.append(newPhoto)
            // Reload the collection view for each new image
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
        // Delete the existing photos
        for photo in savedPhotos {
            dataController.viewContext.delete(photo)
        }
        // Make sure savedPhotos is empty and reset collection view
        savedPhotos.removeAll()
        numberOfPhotos = 0
        collectionView.reloadData()
        // TODO: Change the below to get new photos instead of the same page
        // Get new photos from the Flickr API
        getPhotosFromFlickr()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send selected photo to detail view
        if let vc = segue.destination as? PhotoDetailViewController {
            vc.photo = selectedPhoto
            vc.dataController = dataController
        }
    }
}
