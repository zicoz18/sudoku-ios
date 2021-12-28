//
//  SudokusViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit

class SudokusViewController: UIViewController {
    
    let dataSource = DataSource()
    var sudokus: [Sudoku] = []
    var filteredSudokus: [Sudoku] = []
    var selectedFilter: String = ""
    
    @IBOutlet weak var sudokusCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sudokus"
        dataSource.loadSudokus()
        dataSource.delegate = self
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! SudokuCollectionViewCell
        if let indexPath = self.sudokusCollectionView.indexPath(for: cell) {
            let sudoku = dataSource.getSudokuWithIndex(index: indexPath.row)
            let solveSudokuViewController = segue.destination as! SolveSudokuViewController
            solveSudokuViewController.selectedSudokuUnsolved = sudoku.unsolved
            solveSudokuViewController.workingSudoku = sudoku.unsolved
            solveSudokuViewController.selectedSudokuSolved = sudoku.solved
        }
    }
    
    @IBAction func filterEasy(_ sender: Any) {
        if(selectedFilter == "easy") {
            selectedFilter = ""
        } else {
            selectedFilter = "easy"
        }
        filterSudokus()
    }
    
    @IBAction func filterMedium(_ sender: Any) {
        if(selectedFilter == "medium") {
            selectedFilter = ""
        } else {
            selectedFilter = "medium"
        }
        filterSudokus()
    }
    
    @IBAction func filterHard(_ sender: Any) {
        if(selectedFilter == "hard") {
            selectedFilter = ""
        } else {
            selectedFilter = "hard"
        }
        filterSudokus()
    }
    
    func filterSudokus() {
        if (selectedFilter == "") {
            filteredSudokus = sudokus
            sudokusCollectionView.reloadData()
            return
        }
        filteredSudokus = sudokus.filter { sudoku in return sudoku.difficulty == selectedFilter
        }
        sudokusCollectionView.reloadData()
    }
}

extension SudokusViewController: DataSourceDelegate {
    func leaderboardLoaded() {}
    
    func sudokusLoaded() {
        sudokus = dataSource.getSudokus()
        filteredSudokus = sudokus
        sudokusCollectionView.reloadData()
    }
}

extension SudokusViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredSudokus.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleSudoku", for: indexPath) as! SudokuCollectionViewCell
        let sudoku = filteredSudokus[indexPath.row]
        cell.difficultyLabel.text = sudoku.difficulty
        return cell
    }
}
