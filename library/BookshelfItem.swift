//
//  BookhelfItemView.swift
//  Library
//
//  Created by Andrey Polyskalov on 27.01.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import UIKit

class BookshelfItem: UICollectionViewCell {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func prepareForReuse() {
        cover.image = UIImage()
    }
}