//
//  SudokusViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit
import Firebase
import FirebaseStorage

class SudokusViewController: UIViewController {
    
    let dataSource = DataSource()
    var sudokus: [Sudoku] = []
    var filteredSudokus: [Sudoku] = []
    var selectedFilter: String = ""
    let storage = Storage.storage()
    
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
            let sudoku = filteredSudokus[indexPath.row]
            let solveSudokuViewController = segue.destination as! SolveSudokuViewController
            solveSudokuViewController.sudokuId = sudoku.id
            solveSudokuViewController.sudokuDifficulty = sudoku.difficulty
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
    
    func userSudokuRelationDataAdded() {}
    
    func leaderboardItemDataAdded() {}
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
        let id = sudoku.id
        let storageRef = storage.reference(forURL: "gs://sudokube-7935b.appspot.com/sudokuImages/sudokuImages/image_\(id).png")
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let data = data{
                let image = UIImage(data: data)
                cell.sudokuImage.image = image
                    }
        }
        return cell
    }
}
