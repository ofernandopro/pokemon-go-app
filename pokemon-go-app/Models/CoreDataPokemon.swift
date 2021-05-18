//
//  CoreDataPokemon.swift
//  pokemon-go-app
//
//  Created by Fernando Moreira on 10/05/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPokemon {
    
    // Retrieve context:
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    func retrieveCapturedPokemons(captured: Bool) -> [Pokemon] {
        let context = self.getContext()
        let request = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        request.predicate = NSPredicate(format: "captured == %@", NSNumber(value: captured))
        
        do {
            let pokemons = try context.fetch(request) as [Pokemon]
            return pokemons
        } catch {}
        
        return []
    }
    
    func retrieveAllPokemons() -> [Pokemon] {
        
        let context = self.getContext()
        
        do {
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
            if pokemons.count == 0 {
                self.addAllPokemons()
                return self.retrieveAllPokemons()
            }
            
            return pokemons
        } catch {}
        
        return []
        
    }
    
    func savePokemon(pokemon: Pokemon) {
        
        let context = self.getContext()
        pokemon.captured = true
        
        do {
            try context.save()
        } catch {}
    }
    
    // Add all pokemons:
    func addAllPokemons() {
        
        let context = self.getContext()
        
        self.createPokemon(name: "Abra", imageName: "abra", captured: false)
        self.createPokemon(name: "Bellsprout", imageName: "bellsprout", captured: false)
        self.createPokemon(name: "Bullbasaur", imageName: "bullbasaur", captured: false)
        self.createPokemon(name: "Caterpie", imageName: "caterpie", captured: false)
        self.createPokemon(name: "Charmander", imageName: "charmander", captured: false)
        self.createPokemon(name: "Eevee", imageName: "eevee", captured: false)
        self.createPokemon(name: "Jigglypuff", imageName: "jigglypuff", captured: false)
        self.createPokemon(name: "Mankey", imageName: "mankey", captured: false)
        self.createPokemon(name: "Meowth", imageName: "meowth", captured: false)
        self.createPokemon(name: "Pidgey", imageName: "pidgey", captured: false)
        self.createPokemon(name: "Pikachu", imageName: "pikachu-2", captured: true)
        self.createPokemon(name: "Psyduck", imageName: "psyduck", captured: false)
        self.createPokemon(name: "Rattata", imageName: "rattata", captured: false)
        self.createPokemon(name: "Snorlax", imageName: "snorlax", captured: false)
        self.createPokemon(name: "Squirtle", imageName: "squirtle", captured: false)
        self.createPokemon(name: "Weedle", imageName: "weedle", captured: false)
        self.createPokemon(name: "Zubat", imageName: "zubat", captured: false)
        
        do {
            try context.save()
        } catch {}
        
    }
    
    // Create Pokemons:
    func createPokemon(name: String, imageName: String, captured: Bool) {
        
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        pokemon.name = name
        pokemon.imageName = imageName
        pokemon.captured = captured
    }
    
}
