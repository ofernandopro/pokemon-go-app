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
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self // That is, who will manage this map is our own class
        localizationManager.delegate = self // Who will manage this var is our own class
        localizationManager.requestWhenInUseAuthorization() // Prompts user authorization to have access to location
        localizationManager.startUpdatingLocation() // Updates automatically the user location
        
        // Retrieve pokemons:
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.retrieveAllPokemons() // Return all pokemons to the array pokemons
        
        // Display pokemons:
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            
            if let coordinates = self.localizationManager.location?.coordinate {
                
                let totalPokemons = UInt32(self.pokemons.count)
                let randomPokemonIndex = arc4random_uniform(totalPokemons)
                
                let pokemon = self.pokemons[Int(randomPokemonIndex)]
                
                
                let annotation = PokemonAnnotation(coordinates: coordinates, pokemon: pokemon)
                
                // Generates a random latitude and longitude next to the user
                let randomLatitude = (Double(arc4random_uniform(400)) - 250) / 100000.0
                let randomLongitude = (Double(arc4random_uniform(400)) - 250) / 100000.0
                
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
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            
            annotationView.image = UIImage(named: pokemon.imageName!)
        }
        
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        annotationView.frame = frame
        
        return annotationView
        
    }
    
    // This method is called every time the user taps in an annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation
        let pokemon = (view.annotation as! PokemonAnnotation).pokemon
        
        mapView.deselectAnnotation(annotation, animated: true)
        
        if annotation is MKUserLocation {
            return
        }
        
        if let coordAnnotation = annotation?.coordinate {
            let region = MKCoordinateRegion.init(center: coordAnnotation, latitudinalMeters: 200, longitudinalMeters: 200)
            map.setRegion(region, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.localizationManager.location?.coordinate {
                
                if self.map.visibleMapRect.contains(MKMapPoint(coord)) {
                    self.coreDataPokemon.savePokemon(pokemon: pokemon)
                    self.map.removeAnnotation(annotation!)
                    
                    let alertController = UIAlertController(title: "Congratulations!",
                                                            message: "You captured the pokémon: \(pokemon.name!)",
                                                            preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok",
                                           style: .default,
                                           handler: nil)
                    
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else {
                    let alertController = UIAlertController(title: "You cannot capture it!",
                                                            message: "You need to get closer to capture \(pokemon.name!)",
                                                            preferredStyle: .alert)
                    let ok = UIAlertAction(title: "ok",
                                           style: .default,
                                           handler: nil)
                    
                    alertController.addAction(ok)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

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

