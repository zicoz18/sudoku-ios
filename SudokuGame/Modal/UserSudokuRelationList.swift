//
//  UserSudokuRelationList.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 28.12.2021.
//

import Foundation

struct UserSudokuRelationList: Decodable {
    var relations: [String: UserSudokuRelation]
}
