//
//  PokeAgendaViewController.swift
//  pokemon-go-app
//
//  Created by Fernando Moreira on 12/05/21.
//  Copyright © 2021 Fernando Moreira. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var capturedPokemons: [Pokemon] = []
    var notCapturedPokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let coreDataPokemon = CoreDataPokemon()
        self.capturedPokemons = coreDataPokemon.retrieveCapturedPokemons(captured: true)
        self.notCapturedPokemons = coreDataPokemon.retrieveCapturedPokemons(captured: false)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Captured"
        }
        else {
            return "Not Captured"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.capturedPokemons.count
        }
        else {
            return self.notCapturedPokemons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.capturedPokemons[indexPath.row]
        } else {
            pokemon = self.notCapturedPokemons[indexPath.row]
        }
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        return cell
    }
    
    @IBAction func backToMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
