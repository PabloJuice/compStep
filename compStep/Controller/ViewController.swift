//
//  ViewController.swift
//  compStep
//
//  Created by boredarthur on 24.04.2021.
//

import UIKit
import Realm
import RealmSwift

class ViewController: UIViewController {

    let runService : RunService =  RunService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        runService.deleteAll()
    }
    @IBAction func hello(_ sender: UIButton) {
        var run: RunEntity = RunEntity(ownerId: 1, distance: 2.0, duration: 35.4)
        run.addToLocation(location: Location(latitude: 1,longtitude: 2))
        runService.save(run)
        print(run)
        print(runService.findAll())
        print(runService.checkIfExists(run))
        for ran in runService.findAll(){
            for loc in ran.locations{
                print(loc)
            }
        }
    }
    

}

