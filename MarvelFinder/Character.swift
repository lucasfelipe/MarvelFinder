//
//  Character.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 28/12/16.
//  Copyright © 2016 Kallahir Labs. All rights reserved.
//

import ObjectMapper

class Character: Mappable {
    
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: String?
    var thumbFormat: String?
    var urls: [RelatedLinkItem]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        description <- map["description"]
        thumbnail   <- map["thumbnail.path"]
        thumbFormat <- map["thumbnail.extension"]
        urls        <- map["urls"]
    }
    
}
