//
//  GalleryViewModel.swift
//  Cats
//
//  Created by Gabriel Zambelli on 11/06/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation


class GalleryViewModel {
    
    //MARK: - Properties
    
    private var listImage:[GalleryImage] = []
    
    var count: Int {
        return listImage.count
    }
    
    //MARK: - Methods
    
    func loadGallery(complete: @escaping () -> Void){
        GalleryImageApi.getGallery { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let gallery):
                self.listImage.append(contentsOf: gallery)
                complete()
            case .failure:
                //to do: comportamento em caso de falha
                print("erro")
            }
        }
    }
    
    func getGalleryImage(at indexPath: IndexPath) -> GalleryImage? {
        
        if listImage.count >= indexPath.row {
            return listImage[indexPath.row]
        }
        else{
            return nil
        }
    }
    
}
