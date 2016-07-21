//
//  BooksWithCoversCell.swift
//  Library
//
//  Created by Andrey Polyskalov on 24.09.15.
//  Copyright © 2015 Kachkanar library. All rights reserved.
//

import UIKit

class BookCollectionCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var cover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Rounded corners
        let path = UIBezierPath(roundedRect:cover.bounds, byRoundingCorners:[.TopRight, .BottomRight], cornerRadii: CGSizeMake(5, 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.CGPath
        cover.layer.mask = maskLayer

        // shadow
        cover.layer.shadowColor = UIColor.blackColor().CGColor
        cover.layer.shadowOffset = CGSizeMake(5, 5)
        cover.layer.shadowRadius = 1.0
        cover.layer.shadowOpacity = 0.6
        cover.layer.shouldRasterize = true
    }

    override func prepareForReuse() {
        title.text = nil
        title.hidden = false
        author.text = nil
        author.hidden = false
        cover.image = UIImage(named: "empty")
    }
}
