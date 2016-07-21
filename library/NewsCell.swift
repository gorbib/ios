//
//  NewsCell.swift
//  Library
//
//  Created by Andrey Polyskalov on 03.03.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        title.text = ""
        date.text = ""
    }
}
