//
//  Util.swift
//  Library
//
//  Created by Andrey Polyskalov on 27.09.15.
//  Copyright © 2015 Kachkanar library. All rights reserved.
//

import Foundation

func declOfNum(_ number:Int, titles:[String])->String {
    let cases = [2, 0, 1, 1, 1, 2]
    if(number%100 > 4 && number%100 < 20){
        return titles[2]
    } else {
        return titles[cases[min(number%10, 5)]]
    }
}
