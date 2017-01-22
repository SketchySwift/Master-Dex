//
//  ViewController.swift
//  MasterDex
//
//  Created by Abdurrahman on 12/20/16.
//  Copyright © 2016 Certified Web Developers. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collection: UICollectionView!
	@IBOutlet weak var musicBtn: UIButton!
	
	var pokemon = [Pokemon]()
	var filteredPokemon = [Pokemon]()
	var audioPlayer: AVAudioPlayer!
	var inSearchMode = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		searchBar.backgroundImage = UIImage()
		
		collection.delegate = self
		collection.dataSource = self
		searchBar.delegate = self
		
		let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField
		searchBarTextField?.textColor = UIColor(red: 47.0/255.0, green: 55.0/255.0, blue: 67.0/255.0, alpha: 100)
		searchBarTextField?.font = UIFont.boldSystemFont(ofSize: 15.0)
		searchBarTextField?.attributedPlaceholder = NSAttributedString(string: "Search Pokémon", attributes:[NSForegroundColorAttributeName: UIColor(red: 187.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 100)])
		
		searchBar.returnKeyType = .done
		
		parsePokemonCSV()
		playAudio()
	}

	func playAudio() {
		let path = Bundle.main.path(forResource: "Littleroot", ofType: "mp3")!
		
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
			audioPlayer.prepareToPlay()
			audioPlayer.numberOfLoops = -1
			audioPlayer.play()
		} catch let err as NSError {
			print(err)
		}
	}

	@IBAction func musicBtnPressed(_ sender: UIButton) {
		if audioPlayer.isPlaying {
			audioPlayer.pause()
			sender.alpha = 0.3
		} else {
			audioPlayer.play()
			sender.alpha = 1
		}
	}

	func parsePokemonCSV() {
		let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
		
		do {
			let csv = try CSV(contentsOfURL: path)
			let rows = csv.rows
			//print(rows)
			
			for row in rows {
				let pokeId = Int(row["id"]!)!
				let name = row["identifier"]!
				
				let poke = Pokemon(name: name, pokedexId: pokeId)
				pokemon.append(poke)
				
				//print(pokeId, name)
			}
		} catch let err as NSError {
			print(err)
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if inSearchMode {
			return filteredPokemon.count
		}
		return pokemon.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
			let poke: Pokemon!
			
			if inSearchMode {
				poke = filteredPokemon[indexPath.row]
				cell.configureCell(poke)
			} else {
				poke = pokemon[indexPath.row]
				cell.configureCell(poke)
			}
			
			return cell
		} else {
			return UICollectionViewCell()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		var poke: Pokemon!
		
		if inSearchMode {
			poke = filteredPokemon[indexPath.row]
		} else {
			poke = pokemon[indexPath.row]
		}
		
		performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 105, height: 105)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PokemonDetailVC" {
			if let detailsVC = segue.destination as? PokemonDetailViewController {
				if let poke = sender as? Pokemon {
					detailsVC.pokemon = poke
				} else {
					detailsVC.pokemon = Pokemon(name: "Pikachu", pokedexId: 12)
				}
			}
		}
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}

}

extension ViewController {

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
	
		if searchBar.text == nil || searchBar.text == "" {
			inSearchMode = false
			collection.reloadData()
			view.endEditing(true)
		} else {
			inSearchMode = true
			
			let lower = searchBar.text!.lowercased()
			
			filteredPokemon = pokemon.filter({
				$0.name.range(of: lower) != nil
			})
			
			collection.reloadData()
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
	}



}


