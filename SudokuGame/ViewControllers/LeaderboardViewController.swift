//
//  LeaderboardViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit

class LeaderboardViewController: UIViewController {
    
    let dataSource = DataSource()
    var items: [LeaderboardItem] = []
    var filteredItems: [LeaderboardItem] = []
    var selectedFilter: String = ""
    
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leaderboard"
        dataSource.loadLeaderboard()
        dataSource.delegate = self
    }
    
    @IBAction func filterEasy(_ sender: Any) {
        if(selectedFilter == "easy") {
            selectedFilter = ""
        } else {
            selectedFilter = "easy"
        }
        filterItems()
    }
    
    @IBAction func filterMedium(_ sender: Any) {
        if(selectedFilter == "medium") {
            selectedFilter = ""
        } else {
            selectedFilter = "medium"
        }
        filterItems()
    }
    
    @IBAction func filterHard(_ sender: Any) {
        if(selectedFilter == "hard") {
            selectedFilter = ""
        } else {
            selectedFilter = "hard"
        }
        filterItems()
    }
    
    func filterItems() {
        if (selectedFilter == "") {
            filteredItems = items
            leaderboardTableView.reloadData()
            return
        }
        filteredItems = items.filter { item in return item.difficulty == selectedFilter
        }
        leaderboardTableView.reloadData()
    }
}

extension LeaderboardViewController: DataSourceDelegate {
    func leaderboardLoaded() {
        items = dataSource.getLeaderboardItems()
        filteredItems = items
        leaderboardTableView.reloadData()
    }
    
    func sudokusLoaded() {}
    
    func userSudokuRelationDataAdded() {}
}

extension LeaderboardViewController: UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleUser", for: indexPath) as! UserTableViewCell
        let item = filteredItems[indexPath.row]
        cell.nameLabel.text = item.Name
        cell.scoreLabel.text = String(item.Score)
        return cell
    }
}
