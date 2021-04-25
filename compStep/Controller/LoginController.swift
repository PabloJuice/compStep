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
    
    var user: UserEntity = UserEntity()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userService.deleteAll()
        userService.save(UserEntity(login: "admin", password: "admin"))
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    @IBAction func loginAction(_ sender: UIButton) {
        user = UserEntity(login: loginField.text!, password: passwordField.text!)
            
        if user.isValid(){
            if userService.checkCredentials(user) {
                   self.performSegue(withIdentifier: .tabbar, sender: nil)
            }else{
                showErrorAlert(message: "login failed")
            }
        }else{
            showErrorAlert(message: "check creditals")
        }
            
        print(userService.findAll())
        print(userService.checkIfExists(user))
    }
    @IBAction func registerAction(_ sender: UIButton) {
        if !userService.checkIfExists(UserEntity(login: loginField.text!, password: passwordField.text!)) && UserEntity(login: loginField.text!, password: passwordField.text!).isValid()  {
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

extension LoginController: SegueHandlerType{
    enum SegueIdentifier: String {
        case tabbar = "TabBarViewControllerSegue"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue){
            case .tabbar:
                let destination = segue.destination as! TabBarViewController
                destination.user = user
        }
    }
}
