//
//  CharacterCellViewModel.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

struct CharacterCellViewModel {
  let character: Character
  
  var nameText: String {
    character.name
  }
  
  var birthYearText: String {
    character.birthYear
  }
  
  var genderIcon: String {
    switch character.gender {
    case .male:
      return "male"
    case .female:
      return "female"
    case .NA, .unknown:
      return "unknown"
    }
  }
}
