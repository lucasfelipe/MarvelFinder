//
//  CharacterDetailViewController.swift
//  MarvelFinder
//
//  Created by Itallo Rossi Lucas on 08/01/17.
//  Copyright © 2017 Kallahir Labs. All rights reserved.
//

import UIKit
import AlamofireImage

class CharacterDetailViewController: UITableViewController {

    let requests = MarvelRequests()
    
    var character: Character!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterDescription: UITextView!
    
    @IBOutlet weak var comicsCollectionView: UICollectionView!
    var comicsCollection: Collection!
    var comicsOffset   = 0
    var comicsLoadMore = false
    @IBOutlet weak var seriesCollectionView: UICollectionView!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    private lazy var dataSource : DataSource<FlatArrayDataManager<CollectionItem>, CharacterCellPopulator> = {
        let sections = self.comicsCollection!.items!
        let dataManager = FlatArrayDataManager<CollectionItem>(data: sections)
        
        return DataSource(dataManager: dataManager, cellPopulator: CharacterCellPopulator())
    }()
    
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
        
        self.requests.getCollectionList(characterId: self.character.id!, collectionType: "comics", offset: self.comicsOffset, completion: { (result) in
            DispatchQueue.main.sync {
                self.comicsCollection = result
                self.comicsLoadMore = true
                self.comicsCollectionView.dataSource = self.dataSource
                self.comicsCollectionView.reloadData()
            }
        })
    }
    
    
    // MARK: Table View
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
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
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
    
    // MARK: Load More
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let maxOffset = scrollView.contentSize.width - scrollView.frame.size.width
        
        if (maxOffset - offset) <= 55 {
            switch scrollView {
            case self.comicsCollectionView:
                self.loadMoreComics()
                break
            default:
                break
            }
        }
    }
    
    func loadMoreComics() {
        if self.comicsLoadMore == true {
            self.comicsLoadMore = false
            self.comicsOffset += 20
            
            if self.comicsCollection != nil {
                if self.comicsOffset >= self.comicsCollection.total! {
                    return
                }
            }
            
            self.requests.getCollectionList(characterId: self.character.id!, collectionType: "comics", offset: self.comicsOffset, completion: { (result) in
                for item in result.items! {
                    self.comicsCollection.items!.append(item)
                }
                
                DispatchQueue.main.sync {
                    self.comicsLoadMore = true
                    self.comicsCollectionView.reloadData()
                }
            })
        }
    }
    
    // MARK: Util
    func openRelatedLink(linkType: String) {
        if let relatedLink = urls[linkType] {
            UIApplication.shared.open(NSURL(string: relatedLink) as! URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string:"http://www.marvel.com/") as! URL, options: [:], completionHandler: nil)
        }
    }
    
}
