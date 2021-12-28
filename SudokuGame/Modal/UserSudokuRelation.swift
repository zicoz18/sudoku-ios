//
//  UserSudokuRelation.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 28.12.2021.
//

import Foundation

struct UserSudokuRelation: Codable {
    let solvedSudokuId: Int
    let time: Int
    let userEmail: String
}
