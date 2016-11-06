//
//  BookViewController.swift
//  library
//
//  Created by Andrey Polyskalov on 20.09.15.
//  Copyright © 2015 Andrey Polyskalov. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Variables
    var book: Book!
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var ageRestrictions: UILabel!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var author: UIButton!
    @IBOutlet weak var numberOfPagesOfTheBook: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var lbc: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var departament: UITextView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var related: UICollectionView!
    @IBOutlet weak var contentsButton: UIBarButtonItem!

    var relatedBooks:[Book] = []
    var initialHeaderFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        initialHeaderFrame = header.frame


        self.bookTitle.text = book.title
        
        if let author = book.author {
            self.author.isHidden = false
            self.author.setTitle(author + " >", for: UIControlState())
        } else {
            self.author.isHidden = true
        }

        self.contentsButton.isEnabled = (book.contents.count > 0)


        summary.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10) // 10 pixel padding in summary
        self.summary.text = book.summary

        if let pages = book.pages {
            self.numberOfPagesOfTheBook.isHidden = false
            self.numberOfPagesOfTheBook.text = String(pages) + " стр."
        }
        if let ageRestriction = book.ageRestriction {
            self.ageRestrictions.isHidden = false
            self.ageRestrictions.text = ageRestriction
        }


        category.text = book.category

        if !book.departament.isEmpty {
            var deps = ""
            
            for copy in book.departament {

                departament.insertText(copy)
                deps.append("— \(copy)\n")
            }
            departament.text = deps
        }

        year.text = book.year

        publisher.text = book.publisher

        if let city = book.publisherCity, let name = book.publisher {
            publisher.text = "«\(name)», г. \(city)"
        }
        
        lbc.text = book.lbc

        if let isbn = book.isbn {
            self.coverImage.hnk_setImageFromURL(URL(string:"https://bcover.tk/" + isbn)!)
        }


        if Bookmarks.i.isBookmarked(book.id) {
            self.bookmarkButton.tintColor = UIColor.red
        }




        related.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "Book")

        API.sharedInstance.getRelatedBooks(toBook: book.id){
            result in

            self.relatedBooks = result

            self.related.reloadData()
        }
    }
    
    
    
    // MARK: Scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y

        if offsetY < 0 {
            print(offsetY)

            initialHeaderFrame.size.height -= offsetY;
            self.header.frame = initialHeaderFrame;
            //self.header.frame = CGRectMake(0, offsetY, initialHeaderFrame.width, initialHeaderFrame.height + offsetY);
        }
    }



    // MARK: Share
    
    
    /**
        Share book with system share component
    */
    @IBAction func share(_ sender: AnyObject) {
        let url: URL = URL(string: "http://ec.gorbib.org.ru/records/" + String(book.id))!

        
        let activityViewController = UIActivityViewController(
            activityItems: ["Книга «\(book.title)» в Качканарской библиотеке!", url],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func bookmark(_ sender: AnyObject) {

        if Bookmarks.i.isBookmarked(book.id) {
            Bookmarks.i.remove(book.id)
            bookmarkButton.tintColor = UIColor.white
        } else {
            Bookmarks.i.add(book)
            bookmarkButton.tintColor = UIColor.red
        }
    }
    
    @IBAction func author(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ShowAuthor", sender: nil)
    }



    // MARK: Related books
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.relatedBooks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Book", for: indexPath) as! BookCollectionCell

            let book = relatedBooks[(indexPath as NSIndexPath).row]


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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {

        let relatedBookVC = self.storyboard!.instantiateViewController(withIdentifier: "Book") as! BookViewController
        relatedBookVC.book = relatedBooks[(indexPath as NSIndexPath).row]

        self.navigationController?.pushViewController(relatedBookVC, animated: true)
    }



    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ShowAuthor") {
            let vc = segue.destination as! AuthorController
            
            vc.author = Author(name: book.author!)
        }

        if (segue.identifier == "Contents") {
            let vc = segue.destination as! ContentsController

            vc.contents = book.contents
        }
    }

    
}
