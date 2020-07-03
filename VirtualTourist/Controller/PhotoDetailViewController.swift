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
    var dataController: DataController!
    var photo: Photo!
    
    // MARK: View functions
    override func viewDidLoad() {
        imageView.image = UIImage(data: photo.image!)
    }
    
    // MARK: IBActions
    @IBAction func removePhotoButtonPressed(_ sender: Any) {
        // Delete the photo
        dataController.viewContext.delete(photo)
        // Save the view context
        do {
            try dataController.viewContext.save()
        } catch {
            print("Failed to save deletion of photo.")
        }
        // Pop back to the album view
        navigationController?.popViewController(animated: true)
    }
    
}
