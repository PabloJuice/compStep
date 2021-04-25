//
//  CreateRouteMapViewController.swift
//  compStep
//
//  Created by boredarthur on 25.04.2021.
//

import UIKit
import RealmSwift
import Foundation

class CreateRouteMapViewController: UIViewController {
    @IBOutlet weak var nameInput: UITextField!
    var locations = List<Location>()
    var routeMapService: RouteMapService = RouteMapService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if nameInput.text == ""{
            var alertControllerError = UIAlertController(title: "Name field is empty",
                                                    message: "Please enter name for your route to save", preferredStyle: .alert)
            alertControllerError.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertControllerError, animated: true)
        } else{
            let name = nameInput.text
            let newRoute = RouteMap(locations: locations, name: name)
            routeMapService.save(newRoute)
            performSegue(withIdentifier: .routeMap, sender: nil)
        }
    }
}

extension CreateRouteMapViewController: SegueHandlerType{
    enum SegueIdentifier: String {
        case routeMap = "RouteMapControllerView"
    }
}

