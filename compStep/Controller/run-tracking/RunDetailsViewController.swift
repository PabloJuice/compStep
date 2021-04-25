import UIKit
import MapKit

class RunDetailsViewController: UIViewController {
    
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var PaceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var runService: RunService = RunService()
    var run: RunEntity = RunEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView(){
        let distance = Measurement(value: run.distance.value!, unit: UnitLength.meters)
        let seconds = run.duration.value
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(run.timeStamp as Date)
        let formattedTime = FormatDisplay.time(seconds!)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds!,
                                               outputUnit: UnitSpeed.minutesPerKilometer)
        
        DistanceLabel.text = "Distance: \(formattedDistance)"
        DateLabel.text = "Date: \(formattedDate)"
        PaceLabel.text = "Pace: \(formattedPace)"
        TimeLabel.text = "Time: \(formattedTime)"
        loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion?{
        let locations = run.locations
        
        let latitudes = locations.map{ location -> Double in
            let location = location
            return location.latitude.value!
        }
        
        let longitudes = locations.map{ location -> Double in
            let location = location
            return location.longtitude.value!
        }
        
        let maxLat = latitudes.max()
        let minLat = latitudes.min()
        let maxLong = longitudes.max()
        let minLong = longitudes.min()
        
        let center = CLLocationCoordinate2D(latitude: (minLat! + maxLat!) / 2,
                                            longitude: (minLong! + maxLong!) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat! - minLat!) * 1.3,
                                    longitudeDelta: (maxLong! - minLong!) * 1.3)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> MKPolyline{
        let locations = run.locations
        
        let coords: [CLLocationCoordinate2D] = locations.map{ location in
            let location = location
            return CLLocationCoordinate2D(latitude: location.latitude.value!,
                                          longitude: location.longtitude.value!)
        }
        
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func loadMap(){
        let region = mapRegion()
        mapView.delegate = self
        mapView.setRegion(region!, animated: true)
        print(polyLine())
        mapView.addOverlay(polyLine())
    }
    @IBAction func createRouteMapTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: .route, sender: nil)
    }
}

extension RunDetailsViewController: MKMapViewDelegate{
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

extension RunDetailsViewController: SegueHandlerType{
    enum SegueIdentifier: String {
        case route = "CreateRouteMapViewController"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue){
            case .route:
                let destination = segue.destination as! CreateRouteMapViewController
                destination.locations = run.locations
        }
    }
}
