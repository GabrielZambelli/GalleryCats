//
//  Cat.swift
//  Cats
//
//  Created by Gabriel Zambelli on 11/06/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation


class GalleryImage: Codable {
    
    let id: String
    let title: String?
    let description: String?
    let datetime: Int
    let type: String
    let animated: Bool
    let width: Int
    let height: Int
    let size: Int
    let views: Int?
    let link: String?
    let gifv: String?
    
}

