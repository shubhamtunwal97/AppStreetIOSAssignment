//
//  PhotoListUpdateDelegate.swift
//  AppStreetAssignment
//
//  Created by Shubham Tunwal on 18/10/20.
//

import Foundation

protocol   PhotoListUpdateDelegate:class{
    
    func updateWithNewPhotos(photosDataSource: [Photo])
    
    
}
