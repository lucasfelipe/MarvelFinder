//
//  LicenseViewController.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 06/01/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {
    
    @IBOutlet weak var licenseTextView: UITextView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.licenseTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
}
