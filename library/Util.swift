//
//  Util.swift
//  Library
//
//  Created by Andrey Polyskalov on 27.09.15.
//  Copyright © 2015 Kachkanar library. All rights reserved.
//

import Foundation

func declOfNum(number:Int, titles:[String])->String {
    let cases = [2, 0, 1, 1, 1, 2]
    if(number%100 > 4 && number%100 < 20){
        return titles[2]
    } else {
        return titles[cases[min(number%10, 5)]]
    }
}



extension UIViewController {

    func sendScreenView() {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.title)
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    func trackEvent(category: String, action: String, label: String, value: NSNumber?) {
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value)
        tracker.send(trackDictionary.build() as [NSObject : AnyObject])
    }
}