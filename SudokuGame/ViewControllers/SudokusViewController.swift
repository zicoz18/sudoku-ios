//
//  SudokusViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit

class SudokusViewController: UICollectionViewController {
    
    let dataSource = DataSource()

    @IBOutlet var sudokusCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sudokus"
        dataSource.loadSudokus()
        dataSource.delegate = self
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.getNumberOfSudokus()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleSudoku", for: indexPath) as! SudokuCollectionViewCell
        let sudoku = dataSource.getSudokuWithIndex(index: indexPath.row)
        cell.difficultyLabel.text = sudoku.difficulty
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! SudokuCollectionViewCell
        if let indexPath = self.sudokusCollectionView.indexPath(for: cell) {
            let sudoku = dataSource.getSudokuWithIndex(index: indexPath.row)
            let solveSudokuViewController = segue.destination as! SolveSudokuViewController
            solveSudokuViewController.sudokuId = sudoku.id
            solveSudokuViewController.selectedSudokuUnsolved = sudoku.unsolved
            solveSudokuViewController.workingSudoku = sudoku.unsolved
            solveSudokuViewController.selectedSudokuSolved = sudoku.solved
        }
    }
}

extension SudokusViewController: DataSourceDelegate {
    func leaderboardLoaded() {}
    
    func sudokusLoaded() {
        sudokusCollectionView.reloadData()
    }
}
