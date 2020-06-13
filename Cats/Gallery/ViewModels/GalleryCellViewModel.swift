//
//  GalleryCellViewModel.swift
//  Cats
//
//  Created by Gabriel Zambelli on 11/06/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit


struct GalleryCollectionCellViewModel{
    
    
    //MARK: - Properties
    
    private var galleryImage: GalleryImage
    private static var semaphore = DispatchSemaphore(value: 5)
    
    
    
    init(_ galleryImage: GalleryImage) {
        self.galleryImage = galleryImage
        
    }
    
    //MARK: - Methods
    
    func getImage(complete: @escaping (_ image: UIImage) -> Void) {
        
        if let cacheImage = GalleryCache.shared.getCache(for: NSString(string: galleryImage.id)), let data = cacheImage as? Data, let image = UIImage(data: data){
            complete(image)
        }else{
            loadImage(complete)
        }
    }
   
    private func loadImage(_ complete: @escaping (_ image: UIImage) -> Void){
        guard let urlImage = galleryImage.link, let url = URL(string: urlImage) else { return }
        
        DispatchQueue.global().async() {
            GalleryCollectionCellViewModel.semaphore.wait()
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    GalleryCollectionCellViewModel.semaphore.signal()

                    GalleryCache.shared.setCache(obj: data as AnyObject, forKey: NSString(string: self.galleryImage.id))
                    complete(image)

            }else{
                GalleryCollectionCellViewModel.semaphore.signal()
            }
        }
    }
}
