//
//  PokemonDetailVC.swift
//  pokedex-by-ronAvot
//
//  Created by ron avot on 2.3.2016.
//  Copyright © 2016 ron avot. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    //Variables
    var pokemon:Pokemon!
    //@IBOutlet
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            //this will called when download is done
            self.updateUI()
        }
    }
    
    func updateUI(){
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        pokedexLbl.text = "\(pokemon.pokedexId)"
        baseAttackLbl.text = pokemon.attack
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "NO EVOLUTIONS"
            nextEvoImg.hidden = true
        }
        else
        {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "NEXT EVOLUTION:\(pokemon.nextEvolutionText)"
            if pokemon.nextEvoltionLvl != "" {
                str += "-LVL \(pokemon.nextEvoltionLvl)"
            }
            evoLbl.text = str
        }
        
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

  

}
