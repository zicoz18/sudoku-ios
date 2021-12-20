//
//  SolveSudokuViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 20.12.2021.
//

import UIKit

class SolveSudokuViewController: UIViewController {

    @IBOutlet weak var solveSudokuCollectionView: UICollectionView!
    @IBOutlet weak var solvingNumbersCollectionView: UICollectionView!
    
    var selectedSudokuId: Int?
    let dataSource = DataSource()
    let numberArray = [1, 2, 3, 4, 5, 6, 7, 8, 9]
     
    let sudoku = [
         [
             0,
             0,
             6,
             8,
             9,
             0,
             5,
             0,
             0
         ],
         [
             0,
             0,
             0,
             0,
             0,
             7,
             0,
             0,
             9
         ],
         [
             0,
             0,
             0,
             3,
             0,
             0,
             1,
             2,
             4
         ],
         [
             0,
             1,
             0,
             4,
             0,
             0,
             0,
             9,
             8
         ],
         [
             0,
             0,
             0,
             0,
             0,
             9,
             0,
             0,
             0
         ],
         [
             6,
             9,
             0,
             0,
             2,
             0,
             0,
             0,
             0
         ],
         [
             0,
             0,
             0,
             0,
             0,
             0,
             9,
             4,
             0
         ],
         [
             0,
             6,
             4,
             9,
             7,
             0,
             3,
             5,
             1
         ],
         [
             9,
             7,
             3,
             0,
             1,
             0,
             8,
             0,
             2
         ]
     ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Solve Sudoku"
        dataSource.delegate = self
        //self.solveSudokuCollectionView!.register(SolveSudokuCollectionViewCell.self, forCellWithReuseIdentifier: "solveSudokuCell")
        //self.solvingNumbersCollectionView!.register(SolvingNumbersCollectionViewCell.self, forCellWithReuseIdentifier: "solvingNumbersCell")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SolveSudokuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.solveSudokuCollectionView) {
            return sudoku.capacity * sudoku[0].capacity
        } else {
            return numberArray.capacity
        }
    }
    
    
    func indexPathToRowCol(indexPath: IndexPath) -> [Int] {
        let row = indexPath.row / 9
        let col = indexPath.row % 9
        return [row, col]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.solveSudokuCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "solveSudokuCell", for: indexPath) as! SolveSudokuCollectionViewCell
            let rowCol = indexPathToRowCol(indexPath: indexPath)
            let sudokuCellValue = sudoku[rowCol[0]][rowCol[1]]
            if (sudokuCellValue == 0) {
                cell.valueLabel.text = ""
            } else {
                cell.valueLabel.text = String(sudokuCellValue)
            }
            // Configure the cell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "solvingNumbersCell", for: indexPath) as! SolvingNumbersCollectionViewCell
            let index = indexPath.row
            let solvingNumberValue = numberArray[index]
                cell.numberValueLabel.text = String(solvingNumberValue)
            return cell
        }
    }
}

extension SolveSudokuViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewHeight = collectionView.bounds.height
        if (collectionView == self.solveSudokuCollectionView) {
            return CGSize(width: collectionViewWidth / 9, height: (collectionViewHeight / 9) - 1)
        } else if (collectionView == self.solvingNumbersCollectionView) {
            return CGSize(width: collectionViewWidth / 3, height: collectionViewHeight / 3)
        }
        return CGSize();
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -2
    }
}
 

extension SolveSudokuViewController: DataSourceDelegate {
    func leaderboardLoaded() {
    }
    
    func sudokusLoaded() {
    }
    
}
