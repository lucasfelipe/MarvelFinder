//
//  FlatArrayDataManager.swift
//  MarvelFinder
//
//  Created by Dev on 1/12/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import Foundation

class FlatArrayDataManager<T> : DataManager {
    typealias T = DataManager.DataType
    private var data: [T]
    
    init(data: [T]) {
        self.data = data
    }
    
    convenience init() {
        self.init(data: [T]())
    }
    
    func itemCount() -> Int {
        return data.count
    }
    
    func itemCount(section: Int) -> Int? {
        guard section < 1 else {
            return nil
        }
        
        return itemCount()
    }
    
    func itemAtIndexPath(indexPath: IndexPath) -> T {
        return data[indexPath.row]
    }
    
    func append(newData: [T], toSection: Int) {
        data.append(contentsOf: newData)
    }
    
    func clearData() {
        data.removeAll(keepingCapacity: true)
    }
    
    func sectionCount() -> Int {
        return 1
    }
}
