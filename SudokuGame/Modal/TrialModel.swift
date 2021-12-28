//
//  TrialModel.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 28.12.2021.
//

import Foundation

struct TrialModel: Decodable {
    var leaderboards: [String: LeaderboardItem]
}
