//
//  Bookshelf.swift
//  Library
//
//  Created by Andrey Polyskalov on 26.01.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Bookshelf {
    var id: Int
    var title: String?
    var description: String?
    var cover: URL?
    var books: [Book] = []

    init(json: JSON) {
        self.id = json["id"].intValue

        self.title = json["title"].string
        self.description = json["description"].string

        if let coverURL = json["cover"].string, let cover = URL(string: coverURL) , !coverURL.isEmpty {
            self.cover = cover
        }

    }
}
