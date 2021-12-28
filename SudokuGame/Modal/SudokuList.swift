//
//  Sudokus.swift
//  SudokuGame
//
//  Created by Tolgay Dulger on 28.12.2021.
//

import Foundation

struct SudokuList: Decodable {
    var sudokus: [String: Sudoku]
}
