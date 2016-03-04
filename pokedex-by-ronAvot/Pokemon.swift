//
//  Pokemon.swift
//  pokedex-by-ronAvot
//
//  Created by ron avot on 1.3.2016.
//  Copyright © 2016 ron avot. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    //Variables//
    private var _name:String!
    private var _pokedexId:Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionId: String!
    private var _pokemonUrl: String!
    private var _nextEvolutionLvl: String!
    
    //Getter & Setters//
    var name:String{
        
        return _name
    }
    var pokedexId:Int{
        
        return _pokedexId
    }
    var description:String{
        if _description == nil{
                _description = ""
        }
        return _description
    }
    var type:String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    var defense:String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    var height:String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    var weight:String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    var attack:String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    var nextEvolutionText:String{
        if _nextEvolutionText == nil{
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    var nextEvolutionId:String{
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var nextEvoltionLvl:String{
        if _nextEvolutionLvl == nil{
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    

    //initialzation//
    init(name:String,pokedexId:Int){
        self._name = name
        self._pokedexId = pokedexId
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete){
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url)
            .responseJSON { response in
                let result = response.result
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    
                    if let height = dict["height"] as? String{
                        self._height = height
                    }
                    if let weight = dict["weight"] as? String{
                        self._weight = weight
                    }
                    if let attack = dict["attack"] as? Int{
                        self._attack = "\(attack)"
                    }
                    if let defense = dict["defense"] as? Int{
                        self._defense = "\(defense)"
                    }
                    
                  
                    print(self._height)
                    print(self._weight)
                    print(self._attack)
                    print(self._defense)
                    
                    if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                        if let name = types[0]["name"]{
                            self._type = name.capitalizedString
                        }
                        
                        if types.count > 1 {
                            for var x = 1; x<types.count; x++ {
                                if let name = types[x]["name"]{
                                    self._type! += "/\(name.capitalizedString)"
                                }
                            }
                        }
                    }else{
                      self._type = ""
                    }
                    print(self._type)
                    
                    if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0 {
                        if let url = descArr[0]["resource_uri"]{
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            Alamofire.request(.GET, nsurl).responseJSON { response in
                            
                                let descResult = response.result
                                if let descDict = descResult.value as? Dictionary<String,AnyObject> {
                                    if let description = descDict["description"] as? String{
                                        self._description = description
                                        print(self._description)
                                    }
                                }
                                
                            completed()
                            }
                            
                        }
                    }else{
                        self._description = ""
                    }
                    
                    if let evolution = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolution.count > 0 {
                        if let to = evolution[0]["to"] as? String{
                            //continue if there is no "mega" string in the object
                            if to.rangeOfString("mega") == nil{
                                if let uri = evolution[0]["resource_uri"] as? String{
                                    let newStr = uri.stringByReplacingOccurrencesOfString("api/v1/pokemon/", withString: "")
                                    let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    self._nextEvolutionText = to
                                    self._nextEvolutionId = num
                                    
                                    if let level = evolution[0]["level"] as? Int {
                                        self._nextEvolutionLvl = "\(level)"
                                    }
                                    
                                    print(self._nextEvolutionLvl)
                                    print(self._nextEvolutionId)
                                    print(self._nextEvolutionText)
                                }
                            }
                        }
                    }
                    
                    
                    }
                    
        }
    }
}

