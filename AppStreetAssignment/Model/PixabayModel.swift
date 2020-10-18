
import UIKit

struct PixabayModel: Photo {


    let photoId:String
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
