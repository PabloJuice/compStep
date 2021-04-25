//
//  LoginController.swift
//  compStep
//
//  Created by Yevhen Rozhylo on 25.04.2021.
//

import UIKit
import Realm
import RealmSwift

class LoginController: UIViewController {
    private let userService: UserService = UserService()
        
    @IBOutlet weak var loginField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            userService.deleteAll()
            userService.save(UserEntity(login: "admin", password: "admin"))
            // Do any additional setup after loading the view.
        }

        @IBAction func loginAction(_ sender: UIButton) {
            let user: UserEntity = UserEntity(login: loginField.text!, password: passwordField.text!)
            
            if user.isValid(){
                if userService.checkIfExists(user) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let newRunViewController : NewRunViewController = storyboard.instantiateViewController(identifier: "NewRunViewController")
                    navigationController?.pushViewController(newRunViewController, animated: true)
                }else{
                    showErrorAlert(message: "login failed")
                }
            }else{
                showErrorAlert(message: "check creditals")
            }
            
            print(userService.findAll())
        }
        @IBAction func registerAction(_ sender: UIButton) {
            if !userService.checkIfExists(UserEntity(login: loginField.text!, password: passwordField.text!))  {
                userService.save(UserEntity(login: loginField.text!, password: passwordField.text!))
            }else{
                showErrorAlert(message: "registration failed")
            }
            
        }
        
        func showErrorAlert(message : String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {action in print("error")}))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
