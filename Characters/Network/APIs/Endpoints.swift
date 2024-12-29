//
//  Endpoints.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Foundation

/// Enum representing the available API endpoints for the Rick and Morty API.
///
/// Each case in this enum corresponds to a specific API path, making it easier to manage and
/// interact with different parts of the API. The raw value for each case is the relative path
/// of the endpoint, which is combined with the `baseURL` to form the full URL for requests.
public enum RickAndMortyAPIs: String {
  /// The endpoint for fetching character data.
  case character = "/character"

  /// The base URL for the Rick and Morty API.
  ///
  /// This is the root URL that will be combined with endpoint paths (e.g., `/character`) to create
  /// full URLs for API requests.
  static let baseURL = URL(string: "https://rickandmortyapi.com/api")!
}
