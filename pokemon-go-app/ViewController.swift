//
//  ViewController.swift
//  pokemon-go-app
//
//  Created by Fernando Moreira on 08/05/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var localizationManager = CLLocationManager()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self // That is, who will manage this map is our own class
        localizationManager.delegate = self // Who will manage this var is our own class
        localizationManager.requestWhenInUseAuthorization() // Prompts user authorization to have access to location
        localizationManager.startUpdatingLocation() // Updates automatically the user location
        
        // Display pokemons:
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            
            if let coordinates = self.localizationManager.location?.coordinate {
                let annotation = MKPointAnnotation()
                
                // Generates a random latitude and longitude next to the user
                let randomLatitude = (Double(arc4random_uniform(400)) - 250) / 100000.0
                let randomLongitude = (Double(arc4random_uniform(400)) - 250) / 100000.0
                
                annotation.coordinate = coordinates
                annotation.coordinate.latitude += randomLatitude
                annotation.coordinate.latitude += randomLongitude
                
                self.map.addAnnotation(annotation)
            }
            
        } // Every 8 seconds, this block of code will be executed.
        
    }
    
    // Method to display the annotations as images:
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "player")
        } else {
            annotationView.image = UIImage(named: "pikachu-2")
        }
        
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        annotationView.frame = frame
        
        return annotationView
        
    }
    
    // With this method we can retrieve the user's location (we'll use it to center the user in the map):
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if counter < 3 {
        
            self.center()
            counter += 1
            
        } else {
            localizationManager.stopUpdatingLocation()
        }
        
    }
    
    // This method is called whenever the user's authorization changes (if he authorizes, this method is called, and if he doesn't, it's also called):
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            // alert
            let alertController = UIAlertController(title: "Location Permission",
                                                    message: "For you to hunt pokémons, we need your location. Please enable.",
                                                    preferredStyle: .alert)
            
            let actionSettings = UIAlertAction(title: "Open Settings", style: .default) { (alertSettings) in
                
                if let settings = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settings as URL)
                }
                
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertController.addAction(actionSettings)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func center() {
        if let coordinates = localizationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 200, longitudinalMeters: 200)
            map.setRegion(region, animated: true)
        }
    }
    
    @IBAction func centerPlayer(_ sender: Any) {
        self.center()
    }
    
    @IBAction func openPokedex(_ sender: Any) {
        
    }
    

}

