//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 5/23/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import MapKit
import UIKit
import CoreData

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Other Variables
    var dataController: DataController!
    var loadedMap: Map!
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addLongPressGesture()
        
        // Load the user's last location & zoom level
        loadLastMapPosition()
        // Load in any stored annotations/pins to the map view
        loadPins()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveLastMapPosition()
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
    
    // Allow a long press to drop a pin on the map
    // Below somewhat based on this StackOverflow post:
    // https://stackoverflow.com/questions/54570976/how-to-let-user-to-add-custom-annotation
    func addLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(sender:)))
        view.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            let clickLocation = sender.location(in: view)
            let coordinateLocation = mapView.convert(clickLocation, toCoordinateFrom: view)
            // Create the annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinateLocation
            // Add to Core Data
            let coreAnnotation = Pin(context: dataController.viewContext)
            coreAnnotation.latitude = coordinateLocation.latitude
            coreAnnotation.longitude = coordinateLocation.longitude
            DataHelper.saveData(dataController)
            // Add to map view
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // Show the location's photos, if selected.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // TODO: Add handling of which location was selected
        performSegue(withIdentifier: "showLocationPhotos", sender: nil)
    }
    
    // MARK: Other Functions
    func loadLastMapPosition() {
        // Try to get back the user's last map position
        var mapData = DataHelper.fetchData(dataController, "Map")
        // If it's empty, create the entity
        if mapData.count == 0 {
            let newMap = Map(context: dataController.viewContext)
            DataHelper.saveData(dataController)
            mapData = [newMap]
        }
        
        // Set the map view's zoom level (altitude) and center coordinate
        loadedMap = mapData[0] as? Map
        self.mapView.camera.altitude = CLLocationDistance(loadedMap.cameraHeight)
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(loadedMap.centerLatitude, loadedMap.centerLongitude)
    }
    
    func saveLastMapPosition() {
        // Save the user's last map position
        loadedMap.cameraHeight = Int32(self.mapView.camera.altitude)
        loadedMap.centerLatitude = self.mapView.centerCoordinate.latitude
        loadedMap.centerLongitude = self.mapView.centerCoordinate.longitude
        
        DataHelper.saveData(dataController)
    }
    
    func loadPins() {
        // Fetch any annotations
        let annotationData = DataHelper.fetchData(dataController, "Pin")
        // If there are any, add to the map
        if annotationData.count > 0 {
            for annotation in annotationData {
                let pin = annotation as! Pin
                let pinForMap = MKPointAnnotation()
                pinForMap.coordinate = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
                self.mapView.addAnnotation(pinForMap)
            }
        }
    }

}

