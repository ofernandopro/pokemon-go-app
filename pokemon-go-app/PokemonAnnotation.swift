//
//  PokemonAnnotation.swift
//  pokemon-go-app
//
//  Created by Fernando Moreira on 10/05/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinates: CLLocationCoordinate2D) {
        self.coordinate = coordinates
    }
    
}
