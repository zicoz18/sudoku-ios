//
//  SolveSudokuViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 20.12.2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SolveSudokuViewController: UIViewController {

    @IBOutlet weak var solveSudokuCollectionView: UICollectionView!
    @IBOutlet weak var solvingNumbersCollectionView: UICollectionView!
    
    var dbRef: DatabaseReference! = Database.database().reference()
    
    // for testing
    var solvedSudokuList: [SolvedSudoku] = []

    var selectedSudokuId: Int?
    let dataSource = DataSource()
    let numberArray = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    let solvedSudoku = [
        [
          1, 9, 2, 3, 5,
          7, 8, 4, 6
        ],
        [
          5, 3, 4, 1, 6,
          8, 7, 2, 9
        ],
        [
          6, 7, 8, 2, 4,
          9, 1, 3, 5
        ],
        [
          4, 1, 3, 6, 7,
          5, 2, 9, 8
        ],
        [
          2, 5, 6, 8, 9,
          1, 3, 7, 4
        ],
        [
          7, 8, 9, 4, 2,
          3, 6, 5, 1
        ],
        [
          3, 2, 1, 5, 8,
          4, 9, 6, 7
        ],
        [
          8, 4, 7, 9, 3,
          6, 5, 1, 2
        ],
        [
          9, 6, 5, 7, 1,
          2, 4, 8, 3
        ]
      ]
    let initialSudoku = [[0,0,0,0,0,0,8,0,0],[0,0,4,0,0,8,0,0,9],[0,7,0,0,0,0,0,0,5],[0,1,0,0,7,5,0,0,8],[0,5,6,0,9,1,3,0,0],[7,8,0,0,0,0,0,0,0],[0,2,0,0,0,0,0,0,0],[0,0,0,9,3,0,0,1,0],[0,0,5,7,0,0,4,0,3]]
    var workingSudoku = [[0,0,0,0,0,0,8,0,0],[0,0,4,0,0,8,0,0,9],[0,7,0,0,0,0,0,0,5],[0,1,0,0,7,5,0,0,8],[0,5,6,0,9,1,3,0,0],[7,8,0,0,0,0,0,0,0],[0,2,0,0,0,0,0,0,0],[0,0,0,9,3,0,0,1,0],[0,0,5,7,0,0,4,0,3]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Solve Sudoku"
        dataSource.delegate = self
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
    func checkIfSudokuSolved() -> Bool {
        var solved = true
        for i in 0...8 {
            for j in 0...8 {
                if (workingSudoku[i][j] == 0) {
                    solved = false
                }
            }
        }
        return solved
    }
    
    func writeUserRelatedSolvedSudokuToDB(userEmail: String) {
        dbRef.child("userRelatedSudokus").observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0 ) {
                for relatedSudoku in snapshot.children.allObjects as! [DataSnapshot] {
                    let relatedSudokuObject = relatedSudoku.value as? [String: AnyObject]
                    let relatedSudokuTime = relatedSudokuObject?["time"]
                    let relatedSudokuEmail = relatedSudokuObject?["userMail"]
                    let relatedSudokuSudoku = relatedSudokuObject?["sudoku"]
                    
                    let updatedSudokuDif = relatedSudokuSudoku?["difficulty"]
                    let updatedSudokuSolved = relatedSudokuSudoku?["solved"]
                    let updatedSudokuUnsolved = relatedSudokuSudoku?["unsolved"]
                    
                    let updatedSudokuInstance = UpdatedSudoku(difficulty: updatedSudokuDif as! String, solved: updatedSudokuSolved as! [[Int]] , unsolved: updatedSudokuUnsolved as! [[Int]])
                
                    let solvedSudoku = SolvedSudoku(sudoku: updatedSudokuInstance as! UpdatedSudoku, time: relatedSudokuTime as! Int, userMail: relatedSudokuEmail as! String)
                    
                    // print("RelatedSudoku: \(solvedSudoku)")
                    self.solvedSudokuList.append(solvedSudoku)
                }
                self.solvedSudokuList.forEach {
                    solvedSudoku in
                    print("Diff: \(solvedSudoku.sudoku.difficulty)")
                }
            }
        })
        
        
        let currentSudoku = UpdatedSudoku(difficulty: "hard", solved: solvedSudoku, unsolved: initialSudoku)
        let toAddData = SolvedSudoku(sudoku: currentSudoku, time: 30, userMail: userEmail)
        let sudokuObject: [String: Any] = [
            "solved": toAddData.sudoku.solved,
            "unsolved": toAddData.sudoku.unsolved,
            "difficulty": toAddData.sudoku.difficulty
        ]
        let key = dbRef.child("userRelatedSudokus").childByAutoId().key
        let object: [String: Any] = [
            "userMail": toAddData.userMail as NSString,
            // "sudoku": toAddData.sudoku.solved as NSArray,
            "sudoku": sudokuObject,
            "time": toAddData.time as NSNumber,
            "id": key
        ]
        let userRelatedSudoku = object
        dbRef.child("userRelatedSudokus").child(key!).setValue(object)
        
        /*
        let randomThing3Ref = dbRef.child("randomThing3").childByAutoId()
        let currentSudoku = UpdatedSudoku(difficulty: "hard", solved: solvedSudoku, unsolved: initialSudoku)
         let toAddData = SolvedSudoku(sudoku: currentSudoku, time: 30, userMail: userEmail)
         let sudokuObject: [String: Any] = [
             "solved": toAddData.sudoku.solved,
             "unsolved": toAddData.sudoku.unsolved,
             "difficulty": toAddData.sudoku.difficulty
         ]
         let object: [String: Any] = [
             "userMail": toAddData.userMail as NSString,
             // "sudoku": toAddData.sudoku.solved as NSArray,
             "sudoku": sudokuObject,
             "time": toAddData.time as NSNumber
         ]
        randomThing3Ref.setValue(object, withCompletionBlock: { error, ref in
            if (error == nil) {
                self.dismiss(animated: true, completion: nil)
            } else {
              // handle error
            }
        })
         */
        
    }
    
    func checkSudokuSolving(draggedNumber: Int, droppedIndexPath: IndexPath) {
        print(FirebaseAuth.Auth.auth().currentUser?.email)
        let rowCol = indexPathToRowCol(indexPath: droppedIndexPath)
        if (workingSudoku[rowCol[0]][rowCol[1]] == 0) {
            if (solvedSudoku[rowCol[0]][rowCol[1]] == draggedNumber) {
                workingSudoku[rowCol[0]][rowCol[1]] = draggedNumber
                let droppedCell = solveSudokuCollectionView.cellForItem(at: droppedIndexPath) as! SolveSudokuCollectionViewCell
                droppedCell.valueLabel.text = String(draggedNumber)
                //let isSolved = checkIfSudokuSolved()
                //if (isSolved) {
                    if let userEmail = FirebaseAuth.Auth.auth().currentUser?.email {
                        print("Gets here")
                        writeUserRelatedSolvedSudokuToDB(userEmail: userEmail)
                        // TODO: Navigate to other screen or write solvingSudoku data to db
                    }
                //}
            }
        }
    }
}

extension SolveSudokuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.solveSudokuCollectionView) {
            return initialSudoku.capacity * initialSudoku[0].capacity
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
            let sudokuCellValue = workingSudoku[rowCol[0]][rowCol[1]]
            if (sudokuCellValue == 0) {
                cell.valueLabel.text = ""
            } else {
                cell.valueLabel.text = String(sudokuCellValue)
            }
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
 


extension SolveSudokuViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item  = numberArray[indexPath.row]
        let myItemProvider = NSItemProvider(object: "\(item)" as NSString)
        let dragItem = UIDragItem(itemProvider: myItemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension SolveSudokuViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if let indexPath = coordinator.destinationIndexPath {
            //print("Dropped to the cell at index: \(indexPath.row)")
            let items = coordinator.items
            if (items.count == 1) {
                let item = items.first
                if let draggedItemValue = item?.dragItem.localObject {
                    checkSudokuSolving(draggedNumber: draggedItemValue as! Int, droppedIndexPath: indexPath)
                }
            }
        }
    }
}


extension SolveSudokuViewController: DataSourceDelegate {
    func leaderboardLoaded() {
    }
    
    func sudokusLoaded() {
    }
    
}
