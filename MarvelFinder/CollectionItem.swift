//
//  CollectionItem.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 29/12/16.
//  Copyright © 2016 Kallahir Labs. All rights reserved.
//

import ObjectMapper

class CollectionItem: Mappable, CustomStringConvertible {
    
    var name: String?
    var thumbnail: String?
    var thumbFormat: String?
    
    var description: String {
        return self.name!
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name        <- map["title"]
        thumbnail   <- map["thumbnail.path"]
        thumbFormat <- map["thumbnail.extension"]
    }
    
}
