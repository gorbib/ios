//
//  Book.swift
//  library
//
//  Created by Andrey Polyskalov on 20.09.15.
//  Copyright © 2015 Andrey Polyskalov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Book {

    enum bookType:String {
        case disk = "disk"
        case book = "book"
    }

    var json: JSON!

    var id: Int!
    var type: bookType

    var title: String?
    var author: String?
    var category: String?
    var cover: String? = nil
    var year: String?
    var isbn: String? = nil
    var summary: String?
    var pages: Int?
    var ageRestriction: String?
    var publisher: String?
    var publisherCity: String?
    var subtitle: String? = nil

    var lbc: String?

    var departament: [String] = []
    var contents: [String] = []

    init(json: JSON){

        self.json = json

        self.id = json["id"].intValue

        if(json["type"].string == bookType.book.rawValue) {
            type = .book
        } else {
            type = .disk
        }

        self.title = json["title"].string

        if let author = json["author"].string , !author.isEmpty {
            self.author = author
        }

        if let isbn = json["isbn"].string , !isbn.isEmpty {
            self.isbn = isbn
        } else {
            isbn = nil
        }

        self.subtitle = json["subtitle"].string

        self.category = json["category"].string

        self.summary = json["annotation"].string

        if let pages = json["pages"].int {
            self.pages = pages
        }
        if let ageRestriction = json["age-restriction"].string {
            self.ageRestriction = ageRestriction
        }



        if let copies = json["copies"].array {

            for copy in copies {

                if let dep = copy["departament"].string {
                    let copiesCount = copy["count"].intValue

                    if copiesCount > 1 {
                        self.departament.append(String(copiesCount) + "×" + dep)
                    } else {
                        self.departament.append(dep)
                    }
                    
                }
                /*if let countItems = copy["count"].int {
                    copiesString = "\(copiesString)(\(countItems) экз.) "
                }*/
            }

        }

        if let year_value = json["publication"]["year"].string {
            self.year = year_value
        }
        if let publication = json["publication"]["publisher"].string {
            self.publisher = publication
        }
        if let city = json["publication"]["city"].string {
            self.publisherCity = city
        }

        self.lbc = json["lbc"].string


        if json["contents"].count > 1 {

            for title in json["contents"].array! {
                if let title = title.string {
                    self.contents.append(title)
                }

            }

        }

    }
    
}
