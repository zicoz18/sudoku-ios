//
//  LeaderboardDataSource.swift
//  SudokuGame
//
//  Created by Tolgay Dulger on 19.12.2021.
//

import Foundation

class DataSource {
    private var Leaderboard: [LeaderboardItem] = []
    private var Sudokus: [Sudoku] = []
    private let baseURL = "https://sudokube-7935b-default-rtdb.europe-west1.firebasedatabase.app/"
    var delegate: DataSourceDelegate?
    
    init() {
    }
    
    func getNumberOfUsers() -> Int {
        return Leaderboard.count
    }
    
    func getUserWithIndex(index: Int) -> LeaderboardItem {
        return Leaderboard[index]
    }
    
    func getNumberOfSudokus() -> Int {
        return Sudokus.count
    }
    
    func getSudokuWithIndex(index: Int) -> Sudoku {
        return Sudokus[index]
    }
    
    func loadLeaderboard() {
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)/updatedLeaderboard.json") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    let leaderboardData = try! decoder.decode(TrialModel.self, from: data)
                    var leaderboardArray: [LeaderboardItem] = []
                    for (key, value) in leaderboardData.leaderboards {
                        leaderboardArray.append(value)
                       print("\(value))")
                    }
                    self.Leaderboard = leaderboardArray
                    DispatchQueue.main.async {
                        self.delegate?.leaderboardLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func loadSudokus() {
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)/sudokus.json") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    let sudokuListData = try! decoder.decode([Sudoku].self, from: data)
                    self.Sudokus = sudokuListData
                    DispatchQueue.main.async {
                        self.delegate?.sudokusLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }

}
