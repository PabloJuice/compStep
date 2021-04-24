//
//  NewRunViewController.swift
//  compStep
//
//  Created by boredarthur on 24.04.2021.
//

import UIKit

class NewRunViewController: UIViewController {
    @IBOutlet weak var DataStack: UIStackView!
    
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var PaceLabel: UILabel!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func startTapped(_ sender: UIButton) {
        self.startRun()
    }
    
    @IBAction func stopTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Want to end run?",
                                                message: "Do you with to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) {_ in
            self.stopRun()
            self.performSegue(withIdentifier: .details, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive){_ in
            self.stopRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    private func startRun(){
        DataStack.isHidden = false
        StartButton.isHidden = true
        StopButton.isHidden = false
    }
    
    private func stopRun(){
        DataStack.isHidden = true
        StartButton.isHidden = false
        StopButton.isHidden = true
    }
}


extension NewRunViewController: SegueHandlerType{
    enum SegueIdentifier: String {
        case details = "RunDetailsViewController"
    }
}
