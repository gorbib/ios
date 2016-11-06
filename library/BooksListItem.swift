//
//  BooksListItem.swift
//  Library
//
//  Created by Andrey Polyskalov on 25.09.15.
//  Copyright © 2015 Kachkanar library. All rights reserved.
//

import UIKit

class BooksListItem: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var departaments: UILabel!
    var isbn: String?

    override func awakeFromNib() {
        super.awakeFromNib()

        let path = UIBezierPath(roundedRect:cover.bounds, byRoundingCorners:[.topRight, .bottomRight], cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        cover.layer.mask = maskLayer
        cover.clipsToBounds = true

        departaments.text = ""
    }

    override func prepareForReuse() {
        title.text = nil
        author.text = nil
        departaments.text = ""
        cover.image = UIImage(named: "empty")
    }


}
