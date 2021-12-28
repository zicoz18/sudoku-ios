//
//  DataSourceDelegate.swift
//  SudokuGame
//
//  Created by Tolgay Dulger on 19.12.2021.
//

import Foundation

protocol DataSourceDelegate {
    func leaderboardLoaded()
    func sudokusLoaded()
    func userSudokuRelationDataAdded()
}
