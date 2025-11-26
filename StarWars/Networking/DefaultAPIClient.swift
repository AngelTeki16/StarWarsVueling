//
//  DefaultAPIClient.swift
//  StarWars
//
//  Created by Angel Duarte on 19/11/25.
//

import Foundation

protocol APIClient {
  func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
  func request<T: Decodable>(url: URL) async throws -> T
}

struct Endpoint {
  let path: String
  let queryItems: [URLQueryItem]
  
  init(path: String, queryItems: [URLQueryItem] = []) {
    self.path = path
    self.queryItems = queryItems
  }
}

enum NetworkError: Error {
  case invalidStatus
}

final class DefaultAPIClient: APIClient {
  private let baseURL: URL
  private let session: URLSession
  private let decoder: JSONDecoder
  
  
  init(baseURL: URL,
       session: URLSession = .shared) {
    self.baseURL = baseURL
    self.session = session
    
    let decoder = JSONDecoder()
    self.decoder = decoder
  }
  
  func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
    guard var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)
    else {
      throw NetworkError.invalidStatus
    }
    
    if !endpoint.queryItems.isEmpty {
      components.queryItems = endpoint.queryItems
    }
    
    guard let url = components.url else {
      throw NetworkError.invalidStatus
    }
    
    return try await request(url: url)
  }
  func request<T: Decodable>(url: URL) async throws -> T {
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidStatus
    }
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      print(error)
      throw NetworkError.invalidStatus
    }
  }
}
