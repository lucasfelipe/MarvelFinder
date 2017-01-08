//
//  CharacterDetailViewController.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 08/01/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UITableViewController {

    var character: Character!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterDescription: UITextView!
    
    var urls = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "\(self.character!.thumbnail!)/landscape_xlarge.\(self.character!.thumbFormat!)"
        
        self.characterName.text = self.character!.name
        self.characterImage.af_setImage(withURL: URL(string: urlString)!, placeholderImage: UIImage(named: "placeholder_search"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.3))
        
        if (self.character!.description?.isEmpty)! {
            self.characterDescription.text = "No description available."
        } else {
            self.characterDescription.text = self.character!.description
        }
        
        for url in self.character!.urls! {
            urls[url.linkType!] = url.linkURL!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.characterDescription.contentSize.height+15
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                self.openRelatedLink(linkType: "detail")
                break
            case 1:
                self.openRelatedLink(linkType: "wiki")
                break
            case 2:
                self.openRelatedLink(linkType: "comiclink")
                break
            default:
                print("ERRO")
            }
        }
    }
    
    func openRelatedLink(linkType: String) {
        if let relatedLink = urls[linkType] {
            UIApplication.shared.open(NSURL(string: relatedLink) as! URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string:"http://www.marvel.com/") as! URL, options: [:], completionHandler: nil)
        }
    }
    
}
