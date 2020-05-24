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
    var annotations = [MKAnnotation]()
    // Below are default center coordinate and camera height, if none stored
    var centerCoordinate: CLLocationCoordinate2D!
    var cameraHeight: Int32!
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addLongPressGesture()
        
        // Load the user's last location & zoom level
        loadLastMapPosition()
        // Set the map view's zoom level (altitude) and center coordinate
        self.mapView.camera.altitude = CLLocationDistance(cameraHeight)
        self.mapView.centerCoordinate = centerCoordinate
        
        // TODO: Load in any stored annotations/pins
        
        // Add any annotations to the map
        self.mapView.addAnnotations(annotations)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveLastMapPosition()
    }
    
    // MARK: Map View Functions
    // Allow a long press to drop a pin on the map
    // Below somewhat based on this StackOverflow post:
    // https://stackoverflow.com/questions/54570976/how-to-let-user-to-add-custom-annotation
    func addLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(sender:)))
        view.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        let clickLocation = sender.location(in: view)
        let coordinateLocation = mapView.convert(clickLocation, toCoordinateFrom: view)
        // Create the annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinateLocation
        // Add to annotations array and mapView
        annotations.append(annotation)
        self.mapView.addAnnotation(annotation)
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
        // Extract the center coordinate and camera height
        let loadedMapPosition = mapData[0] as! Map
        let lastLatitude = loadedMapPosition.centerLatitude
        let lastLongitude = loadedMapPosition.centerLongitude
        centerCoordinate = CLLocationCoordinate2DMake(lastLatitude, lastLongitude)
        cameraHeight = loadedMapPosition.cameraHeight
    }
    
    func saveLastMapPosition() {
        // TODO: Save the user's last map position
        DataHelper.saveData(dataController)
    }

}

