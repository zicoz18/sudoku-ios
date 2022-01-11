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
    var relations: [UserSudokuRelation] = []
    var filteredRelations: [UserSudokuRelation] = []
    var solvedSudokuIds: [Int] = []
    var filteredSudokus: [Sudoku] = []
    var selectedFilter: String = "all"
    let pickerOptions: [String] = ["All", "Easy", "Medium", "Hard", "Solved"]
    let storage = Storage.storage()
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var sudokusCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sudokus"
        dataSource.loadAllSudokus()
        dataSource.loadUserSudokuRelations()
        dataSource.delegate = self
        picker.layer.cornerRadius = 10
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
    
    func filterSudokus() {
        if (selectedFilter == "all") {
            filteredSudokus = sudokus
            sudokusCollectionView.reloadData()
            return
        } else if (selectedFilter == "solved") {
            let userEmail = FirebaseAuth.Auth.auth().currentUser?.email ?? ""
            filteredRelations = relations.filter {
                relation in return relation.userEmail == userEmail
            }
            solvedSudokuIds = filteredRelations.map { $0.solvedSudokuId }
            filteredSudokus = sudokus.filter {
                sudoku in return solvedSudokuIds.contains(sudoku.id)
            }
        } else {
            filteredSudokus = sudokus.filter {
                sudoku in return sudoku.difficulty == selectedFilter
            }
        }
        sudokusCollectionView.reloadData()
    }
}

extension SudokusViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFilter = pickerOptions[row].lowercased()
        print(selectedFilter)
        filterSudokus()
    }
}

extension SudokusViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
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

extension SudokusViewController: DataSourceDelegate {
    
    func relationsLoaded() {
        relations = dataSource.getRelations()
    }
    
    func sudokusLoaded() {
        sudokus = dataSource.getSudokus()
        filteredSudokus = sudokus
        sudokusCollectionView.reloadData()
    }
    
    func leaderboardLoaded() {}
    func userSudokuRelationDataAdded() {}
    func leaderboardItemDataAdded() {}
}
