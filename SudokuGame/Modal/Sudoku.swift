//
//  UpdatedSudoku.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 27.12.2021.
//

import Foundation

struct Sudoku: Decodable {
    let difficulty: String
    let solved: [[Int]]
    let unsolved: [[Int]]
}
