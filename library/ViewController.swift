//
//  FirstViewController.swift
//  Library
//
//  Created by Andrey Polyskalov on 22.10.14.
//  Copyright (c) 2014 Andrey Polyskalov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke
import SafariServices

class ViewController: UIViewController, UISearchBarDelegate, SFSafariViewControllerDelegate {
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width - 74, height: 44))
    
    @IBOutlet weak var bookshelvesCollection: UICollectionView!
    @IBOutlet weak var otherBookshelvesCollection: UICollectionView!
    @IBOutlet weak var bookshelvesPageControl: UIPageControl!
    @IBOutlet weak var newBooksCollection: UICollectionView!
    @IBOutlet weak var newsCollection: UICollectionView!
    @IBOutlet weak var othersContstraint: NSLayoutConstraint!

    let cache = Shared.dataCache
    
    var newBooks: [Book] = []
    var bookshelves: [Bookshelf] = []
    var otherBookshelves: [Bookshelf] = []

    var news: [News]  = []

    var bookshelfHeight:CGFloat = 300
    

    var selectedItemInfo: Book!
    var selectedBookshelf: Bookshelf!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Search bar to navigationbar
        searchBar.placeholder = NSLocalizedString("Ищите в библиотеке", comment: "Search bar placeholder text")
        searchBar.tintColor = UIColor.orange

        searchBar.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:searchBar)

        bookshelfHeight = self.otherBookshelvesCollection.frame.width / 16 * 9
        
        newBooksCollection.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "Book")
        bookshelvesCollection.register(UINib(nibName: "Bookshelf", bundle: nil), forCellWithReuseIdentifier: "Bookshelf")
        otherBookshelvesCollection.register(UINib(nibName: "Bookshelf", bundle: nil), forCellWithReuseIdentifier: "Bookshelf")

        cache.fetch(key: "bookshelves") {
            result in

            self.bookshelves.removeAll()
            for (_, bookshelfJson):(String, SwiftyJSON.JSON) in JSON(data: result) {
                let bookshelf = Bookshelf(json: bookshelfJson)

                self.bookshelves.append(bookshelf)
            }

            self.bookshelvesPageControl.numberOfPages = self.bookshelves.count
            self.bookshelvesCollection.reloadData()
            print("Bookshelves fetched from cache")
        }
        self.getFeaturedCollections()
        self.getOtherCollections()
        
        if(self.newBooks.count < 1) {
            self.getNewBooks()
        }

        self.getNews()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.performSegue(withIdentifier: "search", sender: nil)

        return false // False means "dont activate editing process"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.bookshelvesCollection {
            return self.bookshelves.count
        } else if collectionView == self.otherBookshelvesCollection {
            return self.bookshelves.count
        } else if collectionView == self.newsCollection {
            return self.news.count
        } else {
            return self.newBooks.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.bookshelvesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bookshelf", for: indexPath) as! BookshelfItem

            let bookshelf = bookshelves[(indexPath as NSIndexPath).row]

            if let cover = bookshelf.cover {
                cell.cover.hnk_setImageFromURL(cover, placeholder: UIImage())
            }
            cell.title.text = bookshelf.title

            cell.cover.layer.masksToBounds = true
            cell.cover.layer.cornerRadius = 3


            return cell
        } else if collectionView == self.otherBookshelvesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bookshelf", for: indexPath) as! BookshelfItem

            let bookshelf = otherBookshelves[(indexPath as NSIndexPath).row]

            if let cover = bookshelf.cover {
                cell.cover.hnk_setImageFromURL(cover, placeholder: UIImage())
            }
            cell.title.text = bookshelf.title

            cell.cover.layer.masksToBounds = true
            cell.cover.layer.cornerRadius = 3
            
            
            return cell
        } else if collectionView == self.newsCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "News", for: indexPath) as! NewsCell

            let item = news[(indexPath as NSIndexPath).row]
            cell.title.text = item.title
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM"
            cell.date.text = dateFormatter.string(from: item.time as Date)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Book", for: indexPath) as! BookCollectionCell

            let book = newBooks[(indexPath as NSIndexPath).row]


            cell.title.text = book.title

            cell.author.text = book.author

            if let isbn = book.isbn, let url = URL(string: "https://bcover.tk/" + isbn) {

                cell.cover.hnk_setImageFromURL(url, placeholder: UIImage(named:"empty")) {
                    image in

                    cell.author.isHidden = true
                    cell.title.isHidden = true
                    cell.cover.image = image
                }
            } else {
                cell.cover.image = UIImage(named: "empty")
            }

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

        if(collectionView == self.newBooksCollection) {

            let itemsCount:CGFloat = 3.0
            return CGSize(width: collectionView.frame.width/itemsCount - 20, height: 220/155 * (self.view.frame.width/itemsCount - 20));
        } else if(collectionView == self.otherBookshelvesCollection){
            return CGSize(width: collectionView.frame.width, height: bookshelfHeight)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {

        if(collectionView == self.newBooksCollection) {
            self.selectedItemInfo = self.newBooks[(indexPath as NSIndexPath).row]
        
            self.performSegue(withIdentifier: "ShowBook", sender: nil)
        } else if collectionView == self.newsCollection {
            let link = news[(indexPath as NSIndexPath).row].link

            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: link as URL, entersReaderIfAvailable: true)
                self.present(svc, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(link as URL)
            }


        } else if collectionView == self.bookshelvesCollection {
            self.selectedBookshelf = bookshelves[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "Bookshelf", sender: nil)
        } else if collectionView == self.otherBookshelvesCollection {
            self.selectedBookshelf = otherBookshelves[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "Bookshelf", sender: nil)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = bookshelvesCollection.contentOffset.x / bookshelvesCollection.frame.size.width;

        bookshelvesPageControl.currentPage = Int(currentIndex)
    }

    @available(iOS 9.0, *) func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    func getNewBooks() {
        API.sharedInstance.request("books", fail:{
            error in

            print(error)
        }) {
            json in

            self.newBooks.removeAll()
            for (_, bookJson):(String, SwiftyJSON.JSON) in json {
                self.newBooks.append(Book(json: bookJson))
            }
            
            /*if let total = result["total"].int {
                
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .DecimalStyle
                formatter.perMillSymbol = " "
                
                //self.totalBooks.text = formatter.stringFromNumber(total)! + " " + declOfNum(total, titles: ["книга", "книга", "книг"])
            }*/
            
            self.newBooksCollection.reloadData()
        }
    }
    
    func getFeaturedCollections() {
        
        API.sharedInstance.request("bookshelves"){
            result in

            self.cache.set(value: try! result.rawData(), key: "bookshelves")

            self.bookshelves.removeAll()
            for bookshelfData in result where !result.isEmpty {

                self.bookshelves.append( Bookshelf(json: bookshelfData.1))
            }

            self.bookshelvesPageControl.numberOfPages = self.bookshelves.count
            
            self.bookshelvesCollection.reloadData()

        }

    }

    func getOtherCollections() {

        API.sharedInstance.request("bookshelves/latest"){
            result in

            self.otherBookshelves.removeAll()
            for bookshelfData in result where !result.isEmpty {
                self.otherBookshelves.append( Bookshelf(json: bookshelfData.1))
            }

            self.otherBookshelvesCollection.reloadData()
            self.othersContstraint.constant = CGFloat(self.otherBookshelves.count) * self.bookshelfHeight
        }
        
    }

    func getNews(){
        Alamofire.request("https://rss2json.com/api.json", method: .get, parameters: [
                "rss_url":"http://gorbib.org.ru/index.php?option=com_content&view=category&id=49&format=feed&type=rss"
            ]).responseData {
            response in

            if let data = response.data , response.response?.statusCode == 200 {

                let json = JSON(data: data)

                if json["error"].isEmpty {
                    for (_, itemJson):(String, SwiftyJSON.JSON) in json["items"] {
                        self.news.append(News(json: itemJson))
                    }
                    self.newsCollection.reloadData()
                }
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ShowBook") {
            let vc = segue.destination as! BookViewController;
            vc.book = self.selectedItemInfo
        }

        if (segue.identifier == "Bookshelf") {
            let vc = segue.destination as! BookshelfController
            vc.bookshelf = selectedBookshelf
        }
    }
}

