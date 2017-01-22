//
//  Pokemon.swift
//  MasterDex
//
//  Created by Abdurrahman on 12/22/16.
//  Copyright © 2016 Certified Web Developers. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
	
	private var _name: String!
	private var _pokedexId: Int!
	private var _description: String!
	private var _type: String!
	private var _defense: String!
	private var _height: String!
	private var _weight: String!
	private var _attack: String!
	private var _nextEvoLevel: String!
	private var _nextEvoName: String!
	private var _nextEvoId: Int!
	private var _ability: String!
	private var _speed: String!
	private var _pokemonUrl: String!
	
	var nextEvoId: Int {
		if _nextEvoId == nil {
			_nextEvoId = 1
		}
		return _nextEvoId
	}
	
	var nextEvoLevel: String {
		if _nextEvoLevel == nil {
			_nextEvoLevel = ""
		}
		
		return _nextEvoLevel
	}
	
	var description: String {
		if _description == nil {
			_description = "Not found"
		}
		
		return _description
	}
	
	var type: String {
		if _type == nil {
			_type = ""
		}
		
		return _type
	}
	
	var defense: String {
		if _defense == nil {
			_defense = ""
		}
		
		return _defense
	}
	
	var height: String {
		if _height == nil {
			_height = ""
		}
		
		return _height
	}
	
	var weight: String {
		if _weight == nil {
			_weight = ""
		}
		
		return _weight
	}
	
	var attack: String {
		if _attack == nil {
			_attack = ""
		}
		
		return _attack
	}
	
	var nextEvoName: String {
		if _nextEvoName == nil {
			_nextEvoName = ""
		}
		
		return _nextEvoName
	}
	
	var ability: String {
		if _ability == nil {
			_ability = ""
		}
		
		return _ability
	}
	
	var speed: String {
		if _speed == nil {
			_speed = ""
		}
		
		return _speed
	}
	
	var name: String {
		if _name == nil {
			_name = ""
		}
		
		return _name
	}
	
	var pokedexId: Int {
		return _pokedexId
	}
	
	init(name: String, pokedexId: Int) {
		self._name = name
		self._pokedexId = pokedexId
		
		self._pokemonUrl = "http://\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
	}

	func downloadPokemonDetails(completed: @escaping DownloadComplete) {
		Alamofire.request(self._pokemonUrl).responseJSON { (response) in
		
			if let dict = response.result.value as? Dictionary<String, AnyObject> {
				
				if let attack = dict["attack"] as? Int {
					self._attack = "\(attack)"
				}
				
				if let description = dict["description"] as? String {
					self._description = description
				}
				
				if let defense = dict["defense"] as? Int {
					self._defense = "\(defense)"
				}
				
				if let weight = dict["weight"] as? String {
					self._weight = "\(weight)"
				}
				
				if let height = dict["height"] as? String {
					self._height = "\(height)"
				}
				
				if let speed = dict["speed"] as? Int {
					self._speed = "\(speed)"
				}
				
				if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
					if let name = types[0]["name"] as? String {
						self._type = "\(name.capitalized)"
					}
					
					if types.count > 1 {
						if let name2 = types[1]["name"] as? String {
							self._type.append("/\(name2.capitalized)")
						}
					}
					
				} else {
					self._type = ""
				}
				
				if let evolution = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolution.count > 0 {
					if let nextEvoLevel = evolution[0]["level"] as? Int {
						self._nextEvoLevel = "Level \(nextEvoLevel)"
					}
					
					if let nextEvoName = evolution[0]["to"] as? String {
						if nextEvoName.range(of: "mega") == nil {
							self._nextEvoName = "\(nextEvoName)"
						}
					}
					
					if let uri = evolution[0]["resource_uri"] as? String {
						let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
						let nextEvolutionId = newStr.replacingOccurrences(of: "/", with: "")
						self._nextEvoId = Int(nextEvolutionId)
						/*
						Alamofire.request("http://\(URL_BASE)\(url)").responseJSON(completionHandler: { (response) in
							if let dict = response.result.value as? Dictionary<String, AnyObject> {
								if let pokeId = dict["pkdx_id"] as?	Int {
									self._nextEvoId = pokeId
								}
							}
						})
						*/
					}
					print(self._nextEvoId)
				} else {
					self._nextEvoLevel = ""
					self._nextEvoName = "No evolution"
				}
				
				if let description = dict["descriptions"] as? [Dictionary<String, AnyObject>], description.count > 0 {
					if let url = description[0]["resource_uri"] {
						Alamofire.request("http://\(URL_BASE)\(url)").responseJSON(completionHandler: { (response) in
							if let dict = response.result.value as? Dictionary<String, AnyObject> {
								if let desc = dict["description"] as? String {
									let newDescription = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
									self._description = newDescription
									print(newDescription)
								}
							}
							completed()
						})
					}
				} else {
					self._description = ""
				}
				
				if let abilities = dict["abilities"] as? [Dictionary<String, AnyObject>], abilities.count > 0 {
					if let ability = abilities[0]["name"] as? String {
						self._ability = ability.capitalized
					}
					
					if abilities.count > 1 {
						for x in 1..<abilities.count {
							if let ability = abilities[x]["name"] {
								self._ability.append("\n\(ability)")
							}
						}
					}
					print(self._ability)
				} else {
					self._ability = ""
				}
				
				print(self._attack)
				print(self._defense)
				print(self._weight)
				print(self._height)
				print(self._speed)
				print(self._type)
			}
			completed()
		}
			
	}
}



