//
//  Character.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Foundation

// MARK: - CharacterServiceInterface

/// A protocol defining the methods for fetching character data.
/// - `get(query:)`: Fetches a list of characters based on the provided query.
/// - `get(id:)`: Fetches the details of a single character based on the provided `id`.
protocol CharacterServiceInterface {
  /// Fetches a list of characters based on the provided query.
  ///
  /// - Parameter query: An optional `CharacterQuery` used to filter the characters.
  /// - Returns: An asynchronous result containing a list of characters wrapped in `ApiListResult`.
  /// - Throws: An error if the request fails.
  func get(query: CharacterQuery?) async throws -> APIListResult<[Character]>

  /// Fetches the details of a single character based on the provided character `id`.
  ///
  /// - Parameter id: The unique identifier for the character.
  /// - Returns: An asynchronous result containing the details of the character.
  /// - Throws: An error if the request fails.
  func get(id: String) async throws -> CharacterDetails
}

// MARK: - CharacterService

struct CharacterService: CharacterServiceInterface {
  /// Fetches the details of a single character based on the provided character `id`.
  ///
  /// - Parameter id: The unique identifier for the character.
  /// - Returns: An asynchronous result containing the details of the character.
  /// - Throws: An error if the request fails.
  func get(id: String) async throws -> CharacterDetails {
    return try await URLSession.shared.request(path: .character, id: id, httpMethod: .get)
  }

  /// Fetches a list of characters based on the provided query.
  ///
  /// - Parameter query: An optional `CharacterQuery` used to filter the characters.
  /// - Returns: An asynchronous result containing a list of characters wrapped in `ApiListResult`.
  /// - Throws: An error if the request fails.
  func get(query: CharacterQuery?) async throws -> APIListResult<[Character]> {
    return try await URLSession.shared.request(
      path: .character,
      httpMethod: .get,
      queryItems: query?.queryItems() ?? []
    )
  }
}

// MARK: - CharacterServiceDouble

struct CharacterServiceDouble: CharacterServiceInterface {
  /// Mocked character details to simulate fetching a single character.
  var mockCharacterDetails: CharacterDetails?

  /// Mocked list of characters to simulate fetching multiple characters.
  var mockCharacters: [Character]?

  /// Flag indicating whether to throw an error during the request.
  var shouldThrowError: Bool = false

  /// Fetches the details of a single character based on the provided character `id`.
  ///
  /// - Parameter id: The unique identifier for the character.
  /// - Returns: A mocked `CharacterDetails` instance or throws an error based on `shouldThrowError`.
  /// - Throws: A mocked error if `shouldThrowError` is `true`.
  func get(id: String) async throws -> CharacterDetails {
    if shouldThrowError {
      // Simulate an error by throwing a mock NSError (mockError).
      throw mockError
    }
    // Return mocked character details or a default mock if not set.
    return mockCharacterDetails ?? CharacterDetails.mock()
  }

  /// Fetches a list of characters based on the provided query.
  ///
  /// - Parameter query: An optional `CharacterQuery` used to filter the characters.
  /// - Returns: A mocked `ApiListResult<[Character]>` instance or throws an error based on `shouldThrowError`.
  /// - Throws: A mocked error if `shouldThrowError` is `true`.
  func get(query: CharacterQuery?) async throws -> APIListResult<[Character]> {
    if shouldThrowError {
      // Simulate an error by throwing a mock NSError (mockError).
      throw mockError
    }
    // Return mocked list of characters or a default mock if not set.
    return .mock(value: Character.mocks())
  }

  private var mockError: Error {
    NSError(domain: "Mock Error", code: -1)
  }
}
