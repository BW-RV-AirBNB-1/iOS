//
//  LoginViewController.swift
//  5thWheelRV
//
//  Created by Ufuk Türközü on 04.03.20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginSC: UISegmentedControl!
    @IBOutlet weak var landOwnerSC: UISegmentedControl!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //    static var authenticated: Bool = {
//        if UserController.keychain.get("Auth") != nil { return true }
//        else { return false }
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if !LoginViewController.authenticated { performSegue(withIdentifier: "Login", sender: nil) }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        var isLandOwner: Int = 0
        if loginSC.selectedSegmentIndex == 0 {
            guard let username = usernameTF.text, let password = passwordTF.text else { return }
            
            if landOwnerSC.selectedSegmentIndex == 0 {
                isLandOwner = 0
            } else {
                isLandOwner = 1
            }
            
            UserController.shared.logIn(with: TestUser(username: username, password: password, isLandOwner: isLandOwner), completion: { (error) in
                DispatchQueue.main.async {
                    if !self.isError(error) {
                        DispatchQueue.main.async {
                            //LoginViewController.authenticated = true
                            self.performSegue(withIdentifier: "FinishSegue", sender: nil)
                        }
                    }
                }
            })
        } else {
            guard let username = usernameTF.text, let password = passwordTF.text else { return }
            
            let tempUser = TestUser(username: username, password: password, isLandOwner: isLandOwner)
            UserController.shared.signUp(with: tempUser) { (error) in
                DispatchQueue.main.async {
                    if !self.isError(error) {
                       // LoginViewController.authenticated = true
                        self.performSegue(withIdentifier: "FinishSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func changeLoginSegment(_ sender: Any) {
        if loginSC.selectedSegmentIndex == 0 {
            titleLabel.text = "Login"
            loginButton.titleLabel?.text = "Login"
        } else {
            titleLabel.text = "Sign Up"
            loginButton.titleLabel?.text = "Sign Up"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func isError(_ error: Error?) -> Bool {
        if error != nil {
            print(error.debugDescription)
            let popup = UIAlertController(title: "An error occured", message: "Please try again later", preferredStyle: .alert)
            popup.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(popup, animated: true)
            return true
        }
        return false
    }
}
