//
//  ContentsView.swift
//  Library
//
//  Created by Andrey Polyskalov on 28.02.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import UIKit

class ContentsController: UITableViewController {
    var contents:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Item", forIndexPath: indexPath)

        cell.textLabel?.text = contents[indexPath.row]


        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
}
