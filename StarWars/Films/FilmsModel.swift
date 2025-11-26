//
//  FilmsModel.swift
//  StarWars
//
//  Created by Angel Duarte on 24/11/25.
//

import Foundation

struct FilmDTO: Codable {
  let title: String
  let director: String
  let releaseDate: String
  let url: String
  
  enum CodingKeys: String, CodingKey {
    case title
    case director
    case releaseDate = "release_date"
    case url
  }
}

struct Film {
  let id: Int
  let title: String
  let director: String
  let releaseDate: Date
  
  init(id: Int, title: String, director: String, releaseDate: Date) {
    self.id = id
    self.title = title
    self.director = director
    self.releaseDate = releaseDate
  }
  
  init(dto: FilmDTO) {
    self.id = Film.getID(from: dto.url)
    self.title = dto.title
    self.director = dto.director
    self.releaseDate = dateFormatter.date(from: dto.releaseDate) ?? Date.distantPast
  }
  
  private static func getID(from urlString: String) -> Int {
    guard let url = URL(string: urlString) else { return -1 }
    let lastPath = url.lastPathComponent
    return Int(lastPath) ?? -1
  }
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}
