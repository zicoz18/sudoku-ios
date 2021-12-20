//
//  SolveSudokuCollectionViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 20.12.2021.
//

import UIKit

private let reuseIdentifier = "solveSudokuCell"

class SolveSudokuCollectionViewController: UICollectionViewController {
    
    @IBOutlet var solvingSudokuView: UICollectionView!
    
    var selectedSudokuId: Int?
    let dataSource = DataSource()
    
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sudoku.capacity
    }
    
    func indexPathToRowCol(indexPath: IndexPath) -> [Int] {
        let row = indexPath.row / 9
        let col = indexPath.row % 9
        return [row, col]
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "solveSudokuCell", for: indexPath) as! SolveSudokuCollectionViewCell
        let rowCol = indexPathToRowCol(indexPath: indexPath)
        let sudokuCellValue = sudoku[rowCol[0]][rowCol[1]]
        //cell.numberLabel.text = String(sudokuCellValue)
        // Configure the cell
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension SolveSudokuCollectionViewController: DataSourceDelegate {
    
    func leaderboardLoaded() {
        
    }
    
    func sudokusLoaded() {
        
    }
    
    
}
