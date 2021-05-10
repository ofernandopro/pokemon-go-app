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
    var pokemon: Pokemon
    
    init(coordinates: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinates
        self.pokemon = pokemon
    }
    
}
