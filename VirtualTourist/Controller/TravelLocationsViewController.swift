//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 5/23/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import MapKit
import UIKit

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Other Variables
    var annotations = [MKAnnotation]()
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addLongPressGesture()
        
        // TODO: Load the user's last location & zoom level
        // TODO: Load in any stored annotations/pins
        
        // Add any annotations to the map
        self.mapView.addAnnotations(annotations)
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

}

