//
//  MemberVC.swift
//  Kibble
//
//  Created by VICTOR CHU on 2020-05-04.
//  Copyright © 2020 Victor Chu. All rights reserved.
//

import UIKit

class MembersViewController: UITableViewController {

    // MARK: - Properties

    private var members = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MemberCell.self, forCellReuseIdentifier: "cellId")

    }

    override func loadView() {
        super.loadView()
        tableView.tableFooterView = UIView()
    }

    func setup(names: [String]) {
        members = names
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = members[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MemberCell
        cell.configureCell(name: name, image: nil)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
