//
//  Collection.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 29/12/16.
//  Copyright © 2016 Kallahir Labs. All rights reserved.
//

import ObjectMapper

class Collection: Mappable {
    
    var collectionPath: String?
    var available: Int?
    var returned: Int?
    var items: [CollectionItem]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        collectionPath  <- map["collectionURI"]
        available       <- map["available"]
        returned        <- map["returned"]
        items           <- map["items"]
    }
    
}
