import UIKit
import MapKit
import RealmSwift

class RouteMapViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeTitle: UILabel!
    
    var routeMapService: RouteMapService = RouteMapService()
    var last = RouteMap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        last = routeMapService.findAll().last!
        routeTitle.text = last.name
        loadMap()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "TabBarViewController") as! UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    private func polyLine() -> MKPolyline{
        let coords: [CLLocationCoordinate2D] = last.locations.map{ location -> CLLocationCoordinate2D in
            let location = location
            return CLLocationCoordinate2D(latitude: location.latitude.value!,
                                          longitude: location.longtitude.value!)
        }
        
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func mapRegion() -> MKCoordinateRegion?{
        let latitudes = last.locations.map{ location -> Double in
            let location = location
            return location.latitude.value!
        }
        
        let longitudes = last.locations.map{ location -> Double in
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
    
    private func loadMap(){
        let region = mapRegion()
        mapView.delegate = self
        mapView.setRegion(region!, animated: true)
        mapView.addOverlay(polyLine())
    }
}

extension RouteMapViewController: MKMapViewDelegate{
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
