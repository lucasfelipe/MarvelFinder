//
//  Collection.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 29/12/16.
//  Copyright © 2016 Kallahir Labs. All rights reserved.
//

import ObjectMapper

class Collection: Mappable {
    
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var items: [CollectionItem]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        offset  <- map["data.offset"]
        limit   <- map["data.limit"]
        total   <- map["data.total"]
        count   <- map["data.count"]
        items   <- map["data.results"]
    }
    
}
