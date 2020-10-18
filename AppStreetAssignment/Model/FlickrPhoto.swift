//
//  PhotoListUpdateDelegate.swift
//  AppStreetAssignment
//
//  Created by Shubham Tunwal on 18/10/20.
//

import Foundation

struct PixabayPhotoModel: Photo {    
    let photoId:Int
    let previewURL:String
    let fullResURL:String
    

    var thumbnailURL: URL?{
        get{
            if let url =  URL(string: previewURL) {
                return url
            }
            return nil
        }
    }
    
    var highResPhotoURL: URL?{
        get{
            if let url =  URL(string: fullResURL) {
                return url
            }
            return nil
        }
    }
}

