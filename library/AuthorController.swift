//
//  AuthorViewcontroller.swift
//  Library
//
//  Created by Andrey Polyskalov on 16.10.15.
//  Copyright © 2015 Kachkanar library. All rights reserved.
//

import UIKit
import SwiftyJSON

class AuthorController: UITableViewController {

    var author: Author!
    private var books: [Book]! = []
    var selectedItemInfo: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "Book", bundle: nil), forCellReuseIdentifier: "Book")

        self.title = author!.name
        self.navigationItem.title = author!.name
        
        API.sharedInstance.getBooksByAuthor(withName: author.name) {
            result in
            for bookJSON in JSON(result["books"].arrayObject!) {
                self.books.append(Book(json: bookJSON.1))
            }
            self.tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Book", forIndexPath: indexPath) as! BooksListItem

        let book = books[indexPath.row]

        cell.title.text = book.title

        if let isbn = book.isbn, url = NSURL(string: "http://bcover.tk/" + isbn) {
            cell.cover.hnk_setImageFromURL(url, placeholder: UIImage(named:"empty"))
        } else {
            cell.cover.image = UIImage(named: "empty")
        }

        if let author = book.author {
            cell.author.hidden = false
            cell.author.text = author
        } else {
            cell.author.hidden = true
        }


        cell.type.text = book.subtitle
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        self.selectedItemInfo = self.books[indexPath.row]

        self.performSegueWithIdentifier("ShowBook", sender: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? BookViewController where segue.identifier == "ShowBook" {
            vc.book = self.selectedItemInfo
        }
    }
}
