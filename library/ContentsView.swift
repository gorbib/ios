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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)

        cell.textLabel?.text = contents[(indexPath as NSIndexPath).row]


        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
}
