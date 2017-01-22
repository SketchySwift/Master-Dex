//
//  PokeCell.swift
//  MasterDex
//
//  Created by Abdurrahman on 12/24/16.
//  Copyright © 2016 Certified Web Developers. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
	
	@IBOutlet weak var thumbImg: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	var pokemon: Pokemon!
	
	func configureCell(_ pokemon: Pokemon) {
		self.pokemon = pokemon
		
		nameLabel.text = self.pokemon.name.capitalized
		thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		layer.cornerRadius = 5
	}

}
