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
    private var Relations: [UserSudokuRelation] = []
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
    
    func getLeaderboardItems() -> [LeaderboardItem] {
        return Leaderboard
    }
    
    func getNumberOfSudokus() -> Int {
        return Sudokus.count
    }
    
    func getSudokuWithIndex(index: Int) -> Sudoku {
        return Sudokus[index]
    }
    
    func getSudokus() -> [Sudoku] {
        return Sudokus
    }
    
    func getRelations() -> [UserSudokuRelation] {
        return Relations
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
                    let leaderboardData = try! decoder.decode(LeaderboardData.self, from: data)
                    var leaderboardArray: [LeaderboardItem] = []
                    for (_, value) in leaderboardData.leaderboards {
                        leaderboardArray.append(value)
                    }
                    leaderboardArray.sort(by: { $0.Score < $1.Score })
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
        if let url = URL(string: "\(baseURL)/updatedSudokusTrial.json") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    let sudokusData = try! decoder.decode(SudokuList.self, from: data)
                    var sudokuArray: [Sudoku] = []
                    for (_, value) in sudokusData.sudokus {
                        sudokuArray.append(value)
                    }
                    self.Sudokus = sudokuArray
                    DispatchQueue.main.async {
                        self.delegate?.sudokusLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func loadUserSudokuRelations() {
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)/updatedRelations.json") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    let relationData = try! decoder.decode(UserSudokuRelationList.self, from: data)
                    var relationsArray: [UserSudokuRelation] = []
                    for (_, value) in relationData.relations {
                        relationsArray.append(value)
                    }
                    self.Relations = relationsArray
                    DispatchQueue.main.async {
                        self.delegate?.relationsLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func postUserSudokuRelationData(relationData: UserSudokuRelation) {
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)/updatedRelations/relations.json") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try! JSONEncoder().encode(relationData)
            urlRequest.httpBody = jsonData
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.delegate?.userSudokuRelationDataAdded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func postLeaderboardData(leaderboardItemData: LeaderboardItem) {
        let urlSession = URLSession.shared
        if let url = URL(string: "\(baseURL)/updatedLeaderboard/leaderboards.json") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try! JSONEncoder().encode(leaderboardItemData)
            urlRequest.httpBody = jsonData
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.delegate?.leaderboardItemDataAdded()
                    }
                }
            }
            dataTask.resume()
        }
    }

}
