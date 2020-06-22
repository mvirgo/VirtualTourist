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
    
    // MARK: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(selectedCoordinate)
    }


}
