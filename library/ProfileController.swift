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


    let defaults = UserDefaults.standard
    fileprivate var books: [Book]! = []
    var selectedItemInfo: Book!

    override func viewDidLoad() {
        super.viewDidLoad()

        booksTable.register(UINib(nibName: "Book", bundle: nil), forCellReuseIdentifier: "Book")

        booksTable.emptyDataSetSource = self;
        booksTable.emptyDataSetDelegate = self;

        // A little trick for removing the cell separators
        booksTable.tableFooterView = UIView()

        books = Bookmarks.i.get()

        booksTable.reloadData()
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Нет закладок"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "У вас нет книг в закладках"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Books")
    }

    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath) as! BooksListItem

        let book = books[(indexPath as NSIndexPath).row]

        cell.title.text = book.title

        if let isbn = book.isbn {
            cell.cover.hnk_setImageFromURL(URL(string: "https://bcover.tk/" + isbn)!, placeholder: UIImage(named:"empty"))
        } else {
            cell.cover.image = UIImage(named: "empty")
        }

        if let author = book.author {
            cell.author.isHidden = false
            cell.author.text = author
        } else {
            cell.author.isHidden = true
        }


        cell.type.text = book.subtitle

        cell.departaments.text = ""
        for departament in book.departament {
            cell.departaments.text! += departament + " "
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        self.selectedItemInfo = self.books[(indexPath as NSIndexPath).row]

        self.performSegue(withIdentifier: "Book", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }

    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [UITableViewRowAction]? {

        let watchAction = UITableViewRowAction(style: .default, title: "Удалить") {
            action, index in

            let book = self.books[(indexPath as NSIndexPath).row]

            self.books.remove(at: (indexPath as NSIndexPath).row)

            tableView.beginUpdates()

            tableView.deleteRows(at: [indexPath], with: .none)

            tableView.endUpdates()

            tableView.reloadData()

            Bookmarks.i.remove(book.id)

        }


        return [watchAction]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BookViewController , segue.identifier == "Book" {
            vc.book = self.selectedItemInfo
        }
    }
}
