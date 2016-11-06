//
//  Bookmarks.swift
//  Library
//
//  Created by Andrey Polyskalov on 01.03.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import Foundation
import SwiftyJSON

class Bookmarks {
    // Singleton
    class var i: Bookmarks {
        struct Singleton {
            static let i = Bookmarks()
        }
        return Singleton.i
    }

    fileprivate let defs = UserDefaults.standard
    fileprivate var named:[String:AnyObject] = [:]

    init() {
        named = defs.dictionary(forKey: "bookmarks") as [String : AnyObject]? ?? [:]
    }

    
    func get() -> [Book] {

        var items:[Book] = []

//        for bookString in named {
//            if let data = bookString.1.data(using: String.Encoding.utf8, allowLossyConversion: false){
//                let json = JSON(data: data)
//
//                items.append(Book(json: json))
//            }
//        }

        return items
    }

    func isBookmarked(_ bookId:Int) -> Bool {
        return named[String(bookId)] != nil
    }

    func add(_ book:Book) {
        named[String(book.id)] = book.json.rawString()! as AnyObject?

        defs.set(named, forKey: "bookmarks")
        defs.synchronize()
    }

    func remove(_ bookId:Int) {
        named.removeValue(forKey: String(bookId))
        self.defs.set(named, forKey: "bookmarks")
        self.defs.synchronize()
    }
}
