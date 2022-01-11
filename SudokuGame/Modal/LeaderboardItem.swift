//
//  LeaderboardItem.swift
//  SudokuGame
//
//  Created by Tolgay Dulger on 19.12.2021.
//

import Foundation

struct LeaderboardItem: Decodable, Encodable {
    let name: String
    let score: Int
    let difficulty: String
}
