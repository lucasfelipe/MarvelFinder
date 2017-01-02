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

    var publicKey   = ""
    var privateKey  = ""
    let baseURL     = "https://gateway.marvel.com:443/v1/public/characters?orderBy=name&limit=5&offset="
    var offset      = 0
    
    var result: SearchResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.showsVerticalScrollIndicator = false

        let path = Bundle.main.path(forResource: "MarvelAPIKeys", ofType: "plist")
        if let keys = NSDictionary(contentsOfFile: path!) as? Dictionary<String, String> {
            self.publicKey = keys["PublicKey"]!
            self.privateKey = keys["PrivateKey"]!
        } else {
            return
        }
        
        let ts = Date().timeIntervalSince1970.description.replacingOccurrences(of: ".", with: "")
        let hash = MD5("\(ts)\(self.privateKey)\(self.publicKey)")
        let url = URL(string: "\(baseURL)\(offset)&ts=\(ts)&apikey=\(self.publicKey)&hash=\(hash.lowercased())")
        
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                guard let data = data, error == nil else { return }
                
                let text = String(data: data, encoding: String.Encoding.utf8)
                self.result = SearchResult(JSONString: text!)
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            }.resume()
        }
    }
    
    func loadMore(){
        self.offset += 5
        
        let ts = Date().timeIntervalSince1970.description.replacingOccurrences(of: ".", with: "")
        let hash = MD5("\(ts)\(self.privateKey)\(self.publicKey)")
        let url = URL(string: "\(baseURL)\(offset)&ts=\(ts)&apikey=\(self.publicKey)&hash=\(hash.lowercased())")
        
        DispatchQueue.main.async {
            self.getDataFromUrl(url: url!) { (data, response, error) in
                guard let data = data, error == nil else { return }
                
                let text = String(data: data, encoding: String.Encoding.utf8)
                let moreResult = SearchResult(JSONString: text!)
                
                for character in (moreResult?.characters)! {
                    self.result.characters?.append(character)
                }
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
        }.resume()
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 55 {
            self.loadMore()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(self.result.characters![indexPath.row].name)")
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterListCell", for: indexPath) as! CharacterListCell
        
        let urlString = "\(self.result.characters![indexPath.row].thumbnail!)/landscape_xlarge.\(self.result.characters![indexPath.row].thumbFormat!)"
        
        cell.characterImage.af_setImage(withURL: URL(string: urlString)!)
        cell.characterName.text = self.result.characters![indexPath.row].name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
}
