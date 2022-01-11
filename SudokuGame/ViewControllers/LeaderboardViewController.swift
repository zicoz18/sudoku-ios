//
//  LeaderboardViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit
import Firebase

class LeaderboardViewController: UIViewController {
    
    let dataSource = DataSource()
    var items: [LeaderboardItem] = []
    var filteredItems: [LeaderboardItem] = []
    var selectedFilter: String = "all"
    let pickerOptions: [String] = ["All", "Easy", "Medium", "Hard"]
    
    @IBOutlet weak var leaderboardTableView: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leaderboard"
        dataSource.loadLeaderboard()
        dataSource.delegate = self
        picker.layer.cornerRadius = 10
    }
    
    func secondsToString(seconds: Int) -> String {
        let minutes = seconds / 60 % 60
        let second = seconds % 60
        return String(format: "%02i:%02i", minutes, second)
    }
    
    func filterItems() {
        if (selectedFilter == "all") {
            filteredItems = items
            leaderboardTableView.reloadData()
            return
        } else {
            filteredItems = items.filter { item in return item.difficulty == selectedFilter
            }
        }
        leaderboardTableView.reloadData()
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("signed out")
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignIn") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
        } catch {
            print("Could not sign out")
        }
    }
}

extension LeaderboardViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFilter = pickerOptions[row].lowercased()
        print(selectedFilter)
        filterItems()
    }
}

extension LeaderboardViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
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
        cell.rankLabel.text = "\(indexPath.row + 1)-)"
        cell.nameLabel.text = item.name
        cell.scoreLabel.text = secondsToString(seconds: item.score)
        return cell
    }
}

extension LeaderboardViewController: DataSourceDelegate {

    func leaderboardLoaded() {
        items = dataSource.getLeaderboardItems()
        filteredItems = items
        leaderboardTableView.reloadData()
    }
    
    func relationsLoaded() {}
    func sudokusLoaded() {}
    func userSudokuRelationDataAdded() {}
    func leaderboardItemDataAdded() {}
}
