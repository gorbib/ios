//
//  ProfileController.swift
//  Library
//
//  Created by Andrey Polyskalov on 17.02.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet

class ProfileController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    @IBOutlet weak var booksTable: UITableView!


    let defaults = NSUserDefaults.standardUserDefaults()
    private var books: [Book]! = []
    var selectedItemInfo: Book!

    override func viewDidLoad() {
        super.viewDidLoad()

        booksTable.registerNib(UINib(nibName: "Book", bundle: nil), forCellReuseIdentifier: "Book")

        booksTable.emptyDataSetSource = self;
        booksTable.emptyDataSetDelegate = self;

        // A little trick for removing the cell separators
        booksTable.tableFooterView = UIView()

        books = Bookmarks.i.get()

        booksTable.reloadData()
    }

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Нет закладок"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "У вас нет книг в закладках"
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Books")
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Book", forIndexPath: indexPath) as! BooksListItem

        let book = books[indexPath.row]

        cell.title.text = book.title

        if let isbn = book.isbn {
            cell.cover.hnk_setImageFromURL(NSURL(string: "http://bcover.tk/" + isbn)!, placeholder: UIImage(named:"empty"))
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

        cell.departaments.text = ""
        for departament in book.departament {
            cell.departaments.text! += departament + " "
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        self.selectedItemInfo = self.books[indexPath.row]

        self.performSegueWithIdentifier("Book", sender: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let watchAction = UITableViewRowAction(style: .Default, title: "Удалить") {
            action, index in

            let book = self.books[indexPath.row]

            self.books.removeAtIndex(indexPath.row)

            tableView.beginUpdates()

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)

            tableView.endUpdates()

            tableView.reloadData()

            Bookmarks.i.remove(book.id)

        }


        return [watchAction]
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? BookViewController where segue.identifier == "Book" {
            vc.book = self.selectedItemInfo
        }
    }
}
