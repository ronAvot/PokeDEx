//
//  ViewController.swift
//  pokedex-by-ronAvot
//
//  Created by ron avot on 1.3.2016.
//  Copyright © 2016 ron avot. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    
    //@IBOutlets
    @IBOutlet weak var collection:UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Variables
    var pokemon = [Pokemon]()
    var inSearchMode:Bool = false
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.returnKeyType = UIReturnKeyType.Done
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self

        initAudio()
        parsePokemonCSV()
      
    }
    
    
   
    //Functions
    func initAudio() {

        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do{
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
                
            }
            
        }catch let err as NSError{
         print(err.debugDescription)
        }
            
        }
        
    

    //CollectoinView Functions
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pokeCell", forIndexPath: indexPath) as? PokeCell{
            let poke:Pokemon!
            
            if inSearchMode{
                poke = filteredPokemon[indexPath.row]
            }else{
                poke = pokemon[indexPath.row]
            }
            
            cell.configueCell(poke)
            return cell
            
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var poke:Pokemon!
        
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        }else{
            poke = pokemon[indexPath.row]
        }
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count
        }
            return pokemon.count
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
     return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(90 , 90)
    }
    
    //Search Bar Functions
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        }else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            //filtering the array by the name
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            collection.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }

    //@IBActions
    @IBAction func musicButtonPressed(sender: UIButton) {

        if musicPlayer.playing{
            musicPlayer.stop()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC"{
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke
                }
            }
        
    }

}

}