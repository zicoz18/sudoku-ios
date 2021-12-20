//
//  LoginViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: ViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty else {
            print("pass and email cannot be empty")
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {result, err in
            guard err == nil else {
                print("logged in failed")
                return
            }
            print("logged in")
        })
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty else {
            print("pass and email cannot be empty")
            return
        }
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {result, err in
            guard err == nil else {
                print("account creation failed")
                return
            }
            print("account created")
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
  /*  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return FirebaseAuth.Auth.auth().currentUser != nil
    }
*/
}
