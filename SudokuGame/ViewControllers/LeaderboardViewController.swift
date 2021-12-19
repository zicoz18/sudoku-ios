//
//  LeaderboardViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit

class LeaderboardViewController: UITableViewController {
    
    let dataSource = DataSource()
    @IBOutlet var leaderboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leaderboard"
        dataSource.loadLeaderboard()
        dataSource.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.getNumberOfUsers()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleUser", for: indexPath) as! UserTableViewCell
        let user = dataSource.getUserWithIndex(index: indexPath.row)
        cell.nameLabel.text = user.Name
        return cell
    }
}

extension LeaderboardViewController: DataSourceDelegate {
    func leaderboardLoaded() {
        leaderboardTableView.reloadData()
    }
    
    func sudokusLoaded() {}
}
