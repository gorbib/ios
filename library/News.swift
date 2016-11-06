//
//  News.swift
//  Library
//
//  Created by Andrey Polyskalov on 03.03.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import Foundation
import SwiftyJSON

struct News {
    var title:String? = ""
    var link: URL
    var time: Date


    init(json: JSON) {
        title = json["title"].string
        link = URL(string:json["link"].stringValue)!

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"

        time = dateFormatter.date(from: json["pubDate"].stringValue)!
    }
}
