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
    var link: NSURL
    var time: NSDate


    init(json: JSON) {
        title = json["title"].string
        link = NSURL(string:json["link"].stringValue)!

        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"

        time = dateFormatter.dateFromString(json["pubDate"].stringValue)!
    }
}