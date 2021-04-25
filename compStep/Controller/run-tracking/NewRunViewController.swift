//
//  NewRunViewController.swift
//  compStep
//
//  Created by boredarthur on 24.04.2021.
//

import UIKit
import MapKit
import CoreLocation

class NewRunViewController: UIViewController {
    @IBOutlet weak var DataStack: UIStackView!
    
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var PaceLabel: UILabel!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    
    private let locationManager = LocationManager.shared
    private var seconds = 0.0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    private var runService: RunService = RunService()
    private var run: RunEntity = RunEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runService.deleteAll()
        timer?.invalidate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
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
            self.saveRun()
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
        mapViewContainer.isHidden = false
        mapView.removeOverlays(mapView.overlays)
        mapView.delegate = self
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun(){
        DataStack.isHidden = true
        StartButton.isHidden = false
        StopButton.isHidden = true
        mapViewContainer.isHidden = true
        locationManager.stopUpdatingLocation()
    }
    
    private func saveRun(){
        let newRun = RunEntity(ownerId: 1, distance: distance.value, duration: seconds)
        
        for location in locationList{
            let locationObject = Location(latitude: location.coordinate.latitude,
                                          longtitude: location.coordinate.longitude,
                                          timeStamp: location.timestamp as NSDate)
            newRun.addToLocation(location: locationObject)
        }
        runService.save(newRun)
        run = newRun
    }

    func eachSecond(){
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay(){
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerKilometer)
        
        DistanceLabel.text = "Distance: \(formattedDistance)"
        TimeLabel.text = "Time: \(formattedTime)"
        PaceLabel.text = "Pace: \(formattedPace)"
    }
    
    private func startLocationUpdates(){
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
}


extension NewRunViewController: SegueHandlerType{
    enum SegueIdentifier: String {
        case details = "RunDetailsViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue){
            case .details:
                let destination = segue.destination as! RunDetailsViewController
                destination.run = run
        }
    }
}

extension NewRunViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        for newLocation in locations{
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last{
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion.init(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
            }
            locationList.append(newLocation)
        }
    }
}

extension NewRunViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 3
        return renderer
    }
}
