//
//  LeaderboardItem.swift
//  SudokuGame
//
//  Created by Tolgay Dulger on 19.12.2021.
//

import Foundation

struct LeaderboardItem: Decodable {
    let Id: Int
    let Name: String
    let Score: Int
    let difficulty: String
}
