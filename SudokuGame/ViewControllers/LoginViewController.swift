//
//  LoginViewController.swift
//  SudokuGame
//
//  Created by Ziya Icoz on 14.12.2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: ViewController {

    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var validation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.validation = false
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty else {
            errorText.text = "Email address and password cannot be empty"
            self.validation = false
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {result, err in
            guard err == nil else {
                self.errorText.text = "Incorrect password or email address"
                self.validation = false
                return
            }
            self.validation = true
            self.performSegue(withIdentifier: "SignInToBarController", sender: nil)
        })
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty else {
            errorText.text = "Email address and password cannot be empty"
            self.validation = false
            return
        }
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {result, err in
            guard err == nil else {
                self.errorText.text = "Could not sign up"
                self.validation = false
                return
            }
            self.validation = true
            self.performSegue(withIdentifier: "SingUpToBarController", sender: nil)
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return self.validation
    }

}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
