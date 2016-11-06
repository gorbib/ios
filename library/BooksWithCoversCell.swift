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
        let path = UIBezierPath(roundedRect:cover.bounds, byRoundingCorners:[.topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        cover.layer.mask = maskLayer

        // shadow
        cover.layer.shadowColor = UIColor.black.cgColor
        cover.layer.shadowOffset = CGSize(width: 5, height: 5)
        cover.layer.shadowRadius = 1.0
        cover.layer.shadowOpacity = 0.6
        cover.layer.shouldRasterize = true
    }

    override func prepareForReuse() {
        title.text = nil
        title.isHidden = false
        author.text = nil
        author.isHidden = false
        cover.image = UIImage(named: "empty")
    }
}
