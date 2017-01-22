//
//  PokemonDetailViewController.swift
//  MasterDex
//
//  Created by Abdurrahman on 1/4/17.
//  Copyright © 2017 Certified Web Developers. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {

	var pokemon: Pokemon!

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	@IBOutlet weak var nameLbl: UILabel!
	@IBOutlet weak var mainImg: UIImageView!
	@IBOutlet weak var typeLbl: UILabel!
	@IBOutlet weak var pokeId: UILabel!
	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var weightLabel: UILabel!
	@IBOutlet weak var abilitylabel: UILabel!
	@IBOutlet weak var attackLabel: UILabel!
	@IBOutlet weak var defenseLabel: UILabel!
	@IBOutlet weak var speedLabel: UILabel!
	
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var nextEvoLevelLabel: UILabel!
	@IBOutlet weak var currentEvoImage: UIImageView!
	@IBOutlet weak var nextEvoImage: UIImageView!
	@IBOutlet weak var nextEvoNameLabel: UILabel!
	
	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var infoView: DesignableView!
	@IBOutlet weak var arrowImg: UIImageView!
	@IBOutlet weak var moreButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		nameLbl.text = pokemon.name.capitalized
		
		let img = UIImage(named: "\(pokemon.pokedexId)")
		currentEvoImage.image = img
		mainImg.image = img
		pokeId.text = "#\(pokemon.pokedexId)"
		moreButton.isEnabled = false
		
		activityIndicator.startAnimating()
		pokemon.downloadPokemonDetails { 
			self.updateUI()
			if self.descriptionLabel.text != "Not Found" {
				self.activityIndicator.stopAnimating()
				self.moreButton.isEnabled = true
			}
		}
		
		bgView.alpha = 0
		infoView.alpha = 0
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if nextEvoLevelLabel.text == "0" || nextEvoLevelLabel.text == "none" {
			nextEvoLevelLabel.text = ""
		}
	}
	
	func updateUI() {
		attackLabel.text = pokemon.attack
		descriptionLabel.text = pokemon.description
		defenseLabel.text = pokemon.defense
		weightLabel.text = pokemon.weight
		heightLabel.text = pokemon.height
		speedLabel.text = pokemon.speed
		typeLbl.text = pokemon.type
		abilitylabel.text = pokemon.ability
		nextEvoImage.image = UIImage(named: "\(pokemon.nextEvoId)")
		
		if pokemon.nextEvoName == "No Evolution" {
			nextEvoNameLabel.text = ""
		} else {
			nextEvoNameLabel.text = pokemon.nextEvoName
		}
		
		if pokemon.nextEvoLevel == "" {
			nextEvoLevelLabel.text = "No Evolution"
		} else {
			nextEvoLevelLabel.text = pokemon.nextEvoLevel
		}
		
		if nextEvoLevelLabel.text == "No Evolution" {
			nextEvoImage.isHidden = true
			arrowImg.isHidden = true
		}
		
		if nextEvoNameLabel.text != "" && nextEvoImage.isHidden {
			nextEvoNameLabel.text = ""
		}
	}

	@IBAction func closeBtn(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func moreButton(_ sender: Any) {
		UIView.animate(withDuration: 0.5, animations: {
			self.bgView.alpha = 1
		})
		infoView.animation = "slideUp"
		infoView.animate()
	}

	@IBAction func closeGesture(_ sender: UIGestureRecognizer) {
		UIView.animate(withDuration: 0.1, animations
			: {
				self.infoView.animateToNext {
					self.infoView.animation = "slideUp"
					self.infoView.animateTo()
					self.infoView.alpha = 0
				}
		})
		UIView.animate(withDuration: 0.7, animations
			: {
				self.bgView.alpha = 0
		})
	}

}



