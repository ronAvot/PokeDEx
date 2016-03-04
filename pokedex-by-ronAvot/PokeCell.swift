//
//  PokeCell.swift
//  pokedex-by-ronAvot
//
//  Created by ron avot on 1.3.2016.
//  Copyright © 2016 ron avot. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {

    //@IBOutlets//
    @IBOutlet weak var thumbImg:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    
    //Variables//
    var pokemon:Pokemon!
    
    //initilaztion//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    //Functions//
    func configueCell(pokemon:Pokemon){
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
}
