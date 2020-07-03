//
//  PhotoDetailViewController.swift
//  VirtualTourist
//
//  Created by Michael Virgo on 7/2/20.
//  Copyright © 2020 mvirgo. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Other variables
    var photo: Photo!
    
    // MARK: View functions
    override func viewDidLoad() {
        imageView.image = UIImage(data: photo.image!)
    }
    
    // MARK: IBActions
    @IBAction func removePhotoButtonPressed(_ sender: Any) {
        // TODO: Implement functionality for deleting photo
    }
    
}
