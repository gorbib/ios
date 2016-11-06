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
    fileprivate var books: [Book]! = []
    var selectedItemInfo: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "Book", bundle: nil), forCellReuseIdentifier: "Book")

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Book", for: indexPath) as! BooksListItem

        let book = books[(indexPath as NSIndexPath).row]

        cell.title.text = book.title

        if let isbn = book.isbn, let url = URL(string: "https://bcover.tk/" + isbn) {
            cell.cover.hnk_setImageFromURL(url, placeholder: UIImage(named:"empty"))
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
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        self.selectedItemInfo = self.books[(indexPath as NSIndexPath).row]

        self.performSegue(withIdentifier: "ShowBook", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BookViewController , segue.identifier == "ShowBook" {
            vc.book = self.selectedItemInfo
        }
    }
}
