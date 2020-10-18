//
//  PhotoListUpdateDelegate.swift
//  AppStreetAssignment
//
//  Created by Shubham Tunwal on 18/10/20.
//
import UIKit

class DetailViewController: UIViewController,PhotoListUpdateDelegate{

    
    var photo: Photo? = nil
    var currentPosition:Int?
    
    
    var photoList:[Photo]?
    
//    var mainViewInstance:UICollectionViewController?
    
    
    @IBOutlet weak var imageView: CachedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var swipeAreaView: UIView!
    
    override func viewDidLoad() {
        self.activityIndicator.stopAnimating()
        
        if let _ = photo, let highResPhotoURL = photo?.highResPhotoURL{
            if CacheManager.shared.isImageCached(for: highResPhotoURL.absoluteString){
                imageView.loadImage(atURL: highResPhotoURL)
            } else if let thumbnailURL = photo?.thumbnailURL{
                imageView.loadImage(atURL: thumbnailURL)
                activityIndicator.startAnimating()
                imageView.loadImage(atURL: highResPhotoURL, placeHolder: false, completion: {[weak self] in
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                    }
                })
            }
        }
    }
    
    
    func updateWithNewPhotos(photosDataSource: [Photo]) {
        photoList?.append(contentsOf: photosDataSource)
    }
    @IBAction func imageSwipeListener(_ sender: UIPanGestureRecognizer) {
        
        let vel = sender.velocity(in: imageView)
         if vel.x > 0 {
            // user dragged towards the right
            print("right")
         }
         else {
            // user dragged towards the left
            print("left")
         }

         if vel.y > 0 {
            // user dragged towards the down
            print("down")
         }
          else {
            // user dragged towards the up
            print("up")
         }
        }
    
    @IBAction func swipeRight(_ sender: UIButton) {
        
        print("Gre")
    }
    
    @IBAction func swipeLeft(_ sender: UIButton) {
        print("Ge")
        
    }
    
    
    
}
extension DetailViewController: ZoomingViewController{
    
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return self.imageView
    }
}

extension UIPanGestureRecognizer {

    public struct PanGestureDirection: OptionSet {
        public let rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        static let Up = PanGestureDirection(rawValue: 1 << 0)
        static let Down = PanGestureDirection(rawValue: 1 << 1)
        static let Left = PanGestureDirection(rawValue: 1 << 2)
        static let Right = PanGestureDirection(rawValue: 1 << 3)
    }
    
    
    

    private func getDirectionBy(velocity: CGFloat, greater: PanGestureDirection, lower: PanGestureDirection) -> PanGestureDirection {
        if velocity == 0 {
            return []
        }
        return velocity > 0 ? greater : lower
    }

    public func direction(in view: UIView) -> PanGestureDirection {
        let velocity = self.velocity(in: view)
        let yDirection = getDirectionBy(velocity: velocity.y, greater: PanGestureDirection.Down, lower: PanGestureDirection.Up)
        let xDirection = getDirectionBy(velocity: velocity.x, greater: PanGestureDirection.Right, lower: PanGestureDirection.Left)
        return xDirection.union(yDirection)
    }
}
