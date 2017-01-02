//
//  CharacterSearchViewController.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 29/12/16.
//  Copyright © 2016 Kallahir Labs. All rights reserved.
//

import UIKit
import SwiftHash
import ObjectMapper

class CharacterSearchViewController: UITableViewController, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
 
    var publicKey   = ""
    var privateKey  = ""
    let baseURL     = "https://gateway.marvel.com:443/v1/public/characters?"
    var offset      = 0
    
    var result: SearchResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.isTranslucent   = false
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        UISearchBar.appearance().barTintColor = UIColor.systemRed
        UISearchBar.appearance().tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.systemRed

        self.searchController.searchBar.placeholder = "Character Name"
        self.searchController.searchBar.layer.borderWidth = 1
        self.searchController.searchBar.layer.borderColor = UIColor.systemRed.cgColor
        
        let path = Bundle.main.path(forResource: "MarvelAPIKeys", ofType: "plist")
        if let keys = NSDictionary(contentsOfFile: path!) as? Dictionary<String, String> {
            self.publicKey = keys["PublicKey"]!
            self.privateKey = keys["PrivateKey"]!
        } else {
            return
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.containsEmoji {
            let ts = Date().timeIntervalSince1970.description.replacingOccurrences(of: ".", with: "")
            let hash = MD5("\(ts)\(self.privateKey)\(self.publicKey)")
            let url = URL(string: "\(baseURL)nameStartsWith=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))&orderBy=name&limit=10&offset=\(offset)&ts=\(ts)&apikey=\(self.publicKey)&hash=\(hash.lowercased())")
            
            DispatchQueue.main.async {
                self.getDataFromUrl(url: url!) { (data, response, error) in
                    guard let data = data, error == nil else { return }
                    
                    let text = String(data: data, encoding: String.Encoding.utf8)
                    self.result = SearchResult(JSONString: text!)
                    
                    DispatchQueue.main.sync {
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Invalid Text", message: "Please do not insert emojis and other symbols.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.result != nil {
            return (self.result.characters?.count)!
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterSearchCell", for: indexPath) as! CharacterSearchCell
        
        let urlString = "\(self.result.characters![indexPath.row].thumbnail!)/portrait_small.\(self.result.characters![indexPath.row].thumbFormat!)"
        
        cell.characterImage.af_setImage(withURL: URL(string: urlString)!)
        cell.characterName.text = self.result.characters![indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(self.result.characters?[indexPath.row].name)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

