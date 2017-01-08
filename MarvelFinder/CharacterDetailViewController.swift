//
//  CharacterDetailViewController.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 08/01/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UITableViewController {

    var characterName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(self.characterName)")
    }
}
