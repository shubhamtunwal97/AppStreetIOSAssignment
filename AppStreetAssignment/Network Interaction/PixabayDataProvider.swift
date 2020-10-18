//
//  PhotoListUpdateDelegate.swift
//  AppStreetAssignment
//
//  Created by Shubham Tunwal on 18/10/20.
//
import Foundation

private struct PixabayConstants{
    static let apiKey = "18746089-a08e8202b08353b114b7d2b81"
    static let PIXABAY_BASE_URL = "https://pixabay.com"
    static let photo = "photo"
    static let id = "id"
    struct Messages {
        static let searchURLCreationFailed = "Failed to create search URL."
        static let parsingFailed = "Failed to parse result."
    }
}

class PixabayDataProvider: MainViewControllerProtocol{
    
    func searchPhotos(forSearchString searchString: String, pageNumber: Int, andItemsPerPage itemsPerPage: Int, completion: @escaping ([Photo]?, String?)-> Void){
        guard let searchURL = searchURL(forSearchString: searchString, pageNumber: pageNumber, andItemsPerPage: itemsPerPage) else{
            completion(nil, PixabayConstants.Messages.searchURLCreationFailed)
            return
        }
        
        NetworkManager.shared.request(withURL: searchURL, completion:{[weak self] (data, error) in
            if let _ = error {
                completion(nil, error.debugDescription)
            }else{
                if let results = self?.parsePixabayResponse(data){
                    completion(results, nil)
                }else{
                    completion(nil, PixabayConstants.Messages.parsingFailed)
                }
            }
        })
    }
    
    private func searchURL(forSearchString searchString: String, pageNumber: Int, andItemsPerPage itemsPerPage: Int) -> URL?{
        
        guard let escapedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        
        let URLString = "\(PixabayConstants.PIXABAY_BASE_URL)/api/?key=\(PixabayConstants.apiKey)&q=\(escapedSearchString)&pretty=true&per_page=\(itemsPerPage)&page=\(pageNumber+1)"
        
        
        guard let url = URL(string: URLString) else { return nil }
        
        return url
    }
    
    private func parsePixabayResponse(_ data: Data?) -> [PixabayPhotoModel]?{
        guard let data = data else{return nil}
        
        do {
            guard let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else  {return nil}
            var pxbyPhotos = [PixabayPhotoModel]()
            
            
            do {
                let jsonData = try? JSONSerialization.data(withJSONObject:resultsDictionary)
                let decoder=JSONDecoder()
                let pixabayResponse = try decoder.decode(PixabayResponse.self, from: jsonData!)
                
                
                for photo in pixabayResponse.hits{
                    let pixabayPhoto = PixabayPhotoModel(photoId: photo.id, previewURL: photo.previewURL, fullResURL: photo.largeImageURL)
                    pxbyPhotos.append(pixabayPhoto)
                }
                
                
            }catch  {
                
                print("Unexpected error: \(error).")
            }
            
            
            
            
            return pxbyPhotos
        } catch _ {
            return nil
        }
    }
}
