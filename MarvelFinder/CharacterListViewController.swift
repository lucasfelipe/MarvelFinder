//
//  ViewController.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 28/12/16.
//  Copyright © 2016 Kallahir Labs. All rights reserved.
//

import UIKit
import SwiftHash
import ObjectMapper
import AlamofireImage

class CharacterListViewController: UITableViewController {
    
    let requests = MarvelRequests()
    
    var offset = 0
    var result: SearchResult!
    
    @IBOutlet weak var topView: UIView!
    var loadingIndicator: UIActivityIndicatorView!
    
    var loadMoreFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        self.loadingIndicator.color = UIColor.system
        self.loadingIndicator.center = self.topView.center
        
        self.topView.addSubview(self.loadingIndicator)
        self.loadingIndicator.startAnimating()
        
        self.requests.getCharacterList(offset: self.offset) { (result) in
            self.result = result
            
            DispatchQueue.main.sync {
                self.loadingIndicator.stopAnimating()
                self.tableView.tableHeaderView = nil
                self.tableView.reloadData()
                self.loadMoreFlag = true
            }
        }
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterListCell", for: indexPath) as! CharacterListCell
        
        let urlString = "\(self.result.characters![indexPath.row].thumbnail!)/landscape_xlarge.\(self.result.characters![indexPath.row].thumbFormat!)"
        
        cell.characterImage.af_setImage(withURL: URL(string: urlString)!, placeholderImage: UIImage(named: "placeholder_list"), imageTransition: UIImageView.ImageTransition.crossDissolve(0.3))
        cell.characterName.text = self.result.characters![indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.result != nil {
            return (self.result.characters?.count)!
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(self.result.characters![indexPath.row].name)")
        self.performSegue(withIdentifier: "DetailFromList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailFromList" {
            let characterDetailVC = segue.destination as! CharacterDetailViewController
            characterDetailVC.characterName = "passou!"
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }

    // MARK: Load more
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maxOffset - offset) <= 55 {
            self.loadMore()
        }
    }
    
    func loadMore(){
        if self.loadMoreFlag == true {
            self.loadMoreFlag = false
            self.offset += 15
            
            if self.result != nil {
                if self.offset >= self.result.total! {
                    return
                }
            }
            
            self.requests.getCharacterList(offset: self.offset) { (result) in
                for character in (result.characters)! {
                    self.result.characters?.append(character)
                }
                
                DispatchQueue.main.sync {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.tableHeaderView = nil
                    self.tableView.reloadData()
                    self.loadMoreFlag = true
                }
            }
        }
        
    }
    
}
