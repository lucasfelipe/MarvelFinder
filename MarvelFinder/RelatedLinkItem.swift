//
//  RelatedLinkItem.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 08/01/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import ObjectMapper

class RelatedLinkItem: Mappable {
    
    var linkType: String?
    var linkURL: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        linkType <- map["type"]
        linkURL  <- map["url"]
    }
    
}
