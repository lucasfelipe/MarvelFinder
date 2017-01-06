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
    let baseURL     = "https://gateway.marvel.com:443/v1/public/characters?orderBy=name&limit=15&offset="
    var offset      = 0
    
    var result: SearchResult!
    var loadingIndicator: UIActivityIndicatorView!
    
    var loadMoreFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        self.loadingIndicator.color = UIColor.system
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.center.applying(CGAffineTransform(translationX: 0, y: self.view.bounds.minY))
        
        self.view.addSubview(self.loadingIndicator)
        self.loadingIndicator.startAnimating()
        
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
            self.getDataFromUrl(url: url!) { (data, response, error) in
                guard let data = data, error == nil else { return }
                
                let text = String(data: data, encoding: String.Encoding.utf8)
                self.result = SearchResult(JSONString: text!)
                
                DispatchQueue.main.sync {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.reloadData()
                    self.loadMoreFlag = true
                }
            }
        }
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterListCell", for: indexPath) as! CharacterListCell
        
        let urlString = "\(self.result.characters![indexPath.row].thumbnail!)/landscape_xlarge.\(self.result.characters![indexPath.row].thumbFormat!)"
        
        cell.characterImage.af_setImage(withURL: URL(string: urlString)!, placeholderImage: UIImage(named: "placeholder_list"), filter: nil, progress: nil, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: false, completion: nil)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            print("[LOAD MORE]")
            
            self.loadMoreFlag = false
            self.offset += 15
            
//            if self.result != nil {
//                if self.offset > self.result.count
//            }
            
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
                        self.loadMoreFlag = true
                    }
                }
            }
        }
        
    }
    
    // MARK: Util
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}
