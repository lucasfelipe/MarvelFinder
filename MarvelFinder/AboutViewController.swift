//
//  AboutViewController.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 02/01/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {
    
    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appIcon.layer.cornerRadius = 20.0
        self.appIcon.clipsToBounds = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
