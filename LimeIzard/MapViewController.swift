//
//  MapViewController.swift
//  LimeIzard
//
//  Created by Pavel Hamrik on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    var didReceiveLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // LocationManager
    
    func setMapCenter(location: CLLocationCoordinate2D, keepZoomLevel: Bool) {
        if keepZoomLevel {
            mapView.setCenterCoordinate(location, animated: true)
        }
        else {
            let viewRegion = MKCoordinateRegionMakeWithDistance(location, 1000, 1000);
            let adjustedRegion = mapView.regionThatFits(viewRegion)
            mapView.setRegion(adjustedRegion, animated: true)
        }
        self.mapView.showsUserLocation = true;
    }
    
    // LocationManager update
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //print("locations = \(locations)")
        if locationManager.location != nil &&  !didReceiveLocation {
            setMapCenter((locationManager.location?.coordinate)!, keepZoomLevel: false)
            didReceiveLocation = true
            //locationManager.stopUpdatingHeading()
        }
    }


}


//extension MapViewController: CLLocationManagerDelegate {}
