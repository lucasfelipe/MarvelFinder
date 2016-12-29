//
//  CollectionItem.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 29/12/16.
//  Copyright © 2016 Kallahir Labs. All rights reserved.
//

import ObjectMapper

class CollectionItem: Mappable {
    
    var resourceName: String?
    var resourceURL: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        resourceName <- map["name"]
        resourceURL  <- map["resourceURI"]
    }
    
}
