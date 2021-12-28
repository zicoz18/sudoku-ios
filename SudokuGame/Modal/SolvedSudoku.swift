//
//  SolvedSudoku.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 27.12.2021.
//

import Foundation

struct SolvedSudoku: Decodable {
    let sudoku: UpdatedSudoku
    let time: Int
    let userMail: String
}
