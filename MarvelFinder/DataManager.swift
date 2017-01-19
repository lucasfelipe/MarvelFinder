//
//  DataManager.swift
//  MarvelFinder
//
//  Created by Dev on 1/12/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import Foundation
import ObjectMapper

protocol DataManager {
    
    typealias DataType = CollectionItem
    
    func itemCount() -> Int
    func itemCount(section: Int) -> Int?
    func sectionCount() -> Int
    
    func itemAtIndexPath(indexPath: IndexPath) -> DataType
    func append(newData: [DataType], toSection: Int)
    
    func clearData()
}
