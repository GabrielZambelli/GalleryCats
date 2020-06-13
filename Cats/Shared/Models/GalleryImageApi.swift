//
//  GalleryImageApi.swift
//  Cats
//
//  Created by Gabriel Zambelli on 11/06/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation


enum APIError: Error{
    case generic
    
    // TO DO: fazer os cases de error
}

typealias GalleryImageCallback = (Result<[GalleryImage], APIError>) -> Void

class GalleryImageApi{
    
    //MARK: - Properties
    
    private static var basePath = "https://api.imgur.com/3/gallery/search/?q=cats&page=\(nextPage)"
    private static var nextPage = 1{
        didSet{
            basePath = "https://api.imgur.com/3/gallery/search/?q=cats&page=\(nextPage)"
        }
    }
    private static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "multipart/form-data", "Authorization":"Client-ID 1ceddedc03a5d71"]
        configuration.timeoutIntervalForRequest = 40
        configuration.httpMaximumConnectionsPerHost = 6
        configuration.allowsCellularAccess = true
        
        return configuration
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    private init(){}
    
    //MARK: Methods
    
    static func getGallery(complete: @escaping GalleryImageCallback ){
        
        guard let url = URL(string: basePath) else{
            complete(.failure(.generic))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.networkServiceType = .responsiveData
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            var listGaleryimage: [GalleryImage] = []
            
            if let _ = error{
                complete(.failure(.generic))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                complete(.failure(.generic))
                return
            }
            
            if response.statusCode != 200{
                complete(.failure(.generic))
                return
            }
            
            guard let data = data else{
                complete(.failure(.generic))
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: AnyObject]
                
                guard let data = json?["data"] as? [[String:AnyObject]] else {
                    complete(.failure(.generic))
                    return
                }
                
                for item in data{
                    if let jsonData = try? JSONSerialization.data(withJSONObject: item["images"] as Any, options: .fragmentsAllowed){
                        let jsonDecode  = JSONDecoder()
                        jsonDecode.keyDecodingStrategy = .convertFromSnakeCase
                        
                        let jsonGaleryImage = try? JSONDecoder().decode([GalleryImage].self, from: jsonData)
                        
                        if let jsonGaleryImage = jsonGaleryImage {
                            listGaleryimage.append(contentsOf: jsonGaleryImage)
                        }
                    }
                }
                
                if listGaleryimage.count > 0 { nextPage += 1 }
                
                complete(.success(listGaleryimage.filter({ $0.animated == false })))
                
            }
            catch{
                complete(.failure(.generic))
            }
        }
        task.resume()
    }
    
  }

