//
//  GalleryCache.swift
//  Cats
//
//  Created by Gabriel Zambelli on 12/06/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation


class GalleryCache{
    
    //MARK: - Properties - Singleton
    
    static let shared = GalleryCache()
    
    
    private var imageCache:NSCache<NSString, AnyObject> = {
       let cache = NSCache<NSString, AnyObject>()
        cache.countLimit = 200
        return cache
    }()
    
    private init(){
        
    }
    
    //MARK: - Methods
    
    func setCache(obj: AnyObject, forKey: NSString){
        imageCache.setObject(obj, forKey: forKey)
    }
    
    func getCache(for key: NSString) -> AnyObject?{
        return imageCache.object(forKey: key)
    }
}

