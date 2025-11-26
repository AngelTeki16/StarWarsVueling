//
//  CharactersListModel.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

import Foundation

struct PersonDTO: Codable {
  let name: String
  let gender: String
  let birthYear: String
  let films: [String]
  let url: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case gender
    case birthYear = "birth_year"
    case films
    case url
  }
}

struct PeopleResponseDTO: Codable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [PersonDTO]
}

enum Gender {
  case male
  case female
  case NA
  case unknown
  
  init(apiValue: String) {
    switch apiValue.lowercased() {
    case "male":
      self = .male
    case "female":
      self = .female
    case "n/a":
      self = .NA
    default:
      self = .unknown
    }
  }
}

struct Character {
  var id: Int = -1
  var name: String = ""
  var birthYear: String = ""
  var gender: Gender = .unknown
  var filmURLs: [URL] = []
  
  init(id: Int, name: String, birthYear: String, gender: Gender, filmURLs: [URL]) {
    self.id = id
    self.name = name
    self.birthYear = birthYear
    self.gender = gender
    self.filmURLs = filmURLs
  }
}

extension PersonDTO {
  func toDomain() -> Character {
    let id = Character.getID(from: url)
    let gender = Gender(apiValue: gender)
    let urls = films.compactMap { URL(string: $0) }
    return Character(id: id, name: name, birthYear: birthYear, gender: gender, filmURLs: urls)
  }
}

private extension Character {
  static func getID(from urlString: String) -> Int {
    guard let url = URL(string: urlString) else { return -1 }
    let lastPath = url.lastPathComponent
    return Int(lastPath) ?? -1
  }
}

extension Character {
  ///
  /// BBY -> Before battle of Yavin  -> Negativos
  /// ABY -> After battle of Yavin   -> Positivos
  ///
  var birthYearNumeric: Double? {
    let value = birthYear.lowercased()
    
    if value == "unknown" {
      return nil
    }
    if value.hasSuffix("bby") {
      let number = value.replacingOccurrences(of: "bby", with: "")
      return -(Double(number) ?? 0)
    }
    if value.hasSuffix("aby") {
      let number = value.replacingOccurrences(of: "aby", with: "")
      return Double(number) ?? 0
    }
    return nil
  }
}

extension Character: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: Character, rhs: Character) -> Bool {
    lhs.id == rhs.id
  }
}
