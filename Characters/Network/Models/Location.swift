//
//  Location.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Fakery

/// A struct representing a location, where a character might be.
///
/// This struct contains information about the name and URL of a location.
/// It conforms to `Codable` for encoding and decoding from JSON.
///
/// - `name`: The name of the location (e.g., "Earth", "Citadel of Ricks").
/// - `url`: The URL of the location (e.g., a link to an API endpoint describing the location).
struct Location: Codable {
  /// The name of the location (e.g., "Earth", "Citadel of Ricks").
  let name: String

  /// The URL for the location (e.g., an API URL pointing to more information about the location).
  let url: String

  /// A static method to generate a mock `Location` for testing or placeholder purposes.
  ///
  /// This method uses the `Fakery` library to generate random data for the location.
  ///
  /// - Returns: A mock `Location` object with a random city name and URL.
  static func mock() -> Location {
    let faker = Faker()
    return .init(
      name: faker.address.city(),
      url: faker.internet.url()
    )
  }
}
