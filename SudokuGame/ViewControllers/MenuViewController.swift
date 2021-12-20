//
//  MenuViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit
import FirebaseAuth

class MenuViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOut(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("signed out")
        } catch {
            print("could not sign out")
        }
    }
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
