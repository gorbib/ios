//
//  Collectioncontroller.swift
//  Library
//
//  Created by Andrey Polyskalov on 23.01.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class BookshelfController: UITableViewController {
    var bookshelf: Bookshelf!

    private var books: [Book] = []
    private var selectedBook: Book!

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionView: UITextView!

    var header: UIView!
    let coverLayer = CALayer()
    var initialHeaderFrame:CGRect!
    private var kTableHeaderHeight: CGFloat = 375.0



    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = bookshelf.title

        descriptionView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10) // 10 pixel padding
        descriptionView.text = bookshelf.description

        if let coverURL = bookshelf.cover {
            cover.hnk_setImageFromURL(coverURL)
        }



        self.tableView.registerNib(UINib(nibName: "Book", bundle: nil), forCellReuseIdentifier: "Book")





        header = tableView.tableHeaderView
        tableView.tableHeaderView = nil

        self.initialHeaderFrame = header.frame

        self.tableView.addSubview(header)
        kTableHeaderHeight = header.frame.height

        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()


        //self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())



        API.sharedInstance.request("bookshelves/" + String(bookshelf.id)){
            result in

            print(result)

            for bookJSON in result {
                self.books.append( Book(json: bookJSON.1) )
            }

            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        self.scrollViewDidScroll(self.tableView)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }

        header.frame = headerRect
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        

        /*let NAVBAR_CHANGE_POINT:CGFloat = initialHeaderFrame.height / 2

        //updateHeaderView()

        let color: UIColor = UIColor(red: 1, green: 0.56, blue: 0.07, alpha: 1)


        let offsetY = scrollView.contentOffset.y + initialHeaderFrame.height - 20

        if offsetY < 0 {
            print(offsetY)
            self.cover.frame = CGRectMake(0, offsetY, initialHeaderFrame.width - offsetY, initialHeaderFrame.height - offsetY);
            //self.cover.center = CGPointMake(self.cover.center.x, self.cover.center.y);
        }

        if offsetY > NAVBAR_CHANGE_POINT {
            let alpha: CGFloat = min(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64))
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }*/

    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Book", forIndexPath: indexPath) as! BooksListItem

        let book = books[indexPath.row]

        cell.title.text = book.title

        if let isbn = book.isbn {
            cell.cover.hnk_setImageFromURL(NSURL(string: "http://bcover.tk/" + isbn)!, placeholder: UIImage(named:"empty"))
        }

        cell.isbn = book.isbn

        if let author = book.author {
            cell.author.hidden = false
            cell.author.text = author
        } else {
            cell.author.hidden = true
        }

        cell.type.text = book.subtitle

        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedBook = books[indexPath.row]
        self.performSegueWithIdentifier("Book", sender: nil)
    }



    //let NAVBAR_CHANGE_POINT = 100.0 // Replace it by your value, keep it double

//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//
//        let color: UIColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
//        let offsetY = Double(scrollView.contentOffset.y)
//
//        if offsetY > NAVBAR_CHANGE_POINT {
//            let alpha: CGFloat = CGFloat(min(1.0, 1.0 - ((NAVBAR_CHANGE_POINT + 64.0 - offsetY) / 64.0)))
//            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
//
//        } else {
//            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
//        }
//    }




    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Book") {
            let vc = segue.destinationViewController as! BookViewController;
            vc.book = self.selectedBook
        }
    }

    



//    let NAVBAR_CHANGE_POINT = 50
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//
//        var color: UIColor = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
//        var offsetY: CGFloat = scrollView.contentOffset.y
//        if Int(offsetY) > NAVBAR_CHANGE_POINT {
//            var alpha: CGFloat = CGFloat(min(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - Int(offsetY)) / 64)))
//            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
//        } else {
//            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
//        }
//    }
}
