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

    private let defs = NSUserDefaults.standardUserDefaults()
    private var named:[String:AnyObject] = [:]

    init() {
        named = defs.dictionaryForKey("bookmarks") ?? [:]
    }

    
    func get() -> [Book] {

        var items:[Book] = []

        for bookString in named {
            if let data = bookString.1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false){
                let json = JSON(data: data)

                items.append(Book(json: json))
            }
        }

        return items
    }

    func isBookmarked(bookId:Int) -> Bool {
        return named[String(bookId)] != nil
    }

    func add(book:Book) {
        named[String(book.id)] = book.json.rawString()!

        defs.setObject(named, forKey: "bookmarks")
        defs.synchronize()
    }

    func remove(bookId:Int) {
        named.removeValueForKey(String(bookId))
        self.defs.setObject(named, forKey: "bookmarks")
        self.defs.synchronize()
    }
}