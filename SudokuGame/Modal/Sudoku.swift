//
//  Sudoku.swift
//  SudokuGame
//
//  Created by Tolgay Dulger on 19.12.2021.
//

import Foundation

struct Sudoku: Decodable {
    let Id: Int
    let difficulty: String
    let Table: [[Int]]
}
