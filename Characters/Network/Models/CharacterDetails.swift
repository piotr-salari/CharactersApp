//
//  CharacterDetails.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Fakery

/// A struct representing detailed information about a character.
///
/// This struct contains additional properties beyond the basic character info (e.g., gender, location).
/// It conforms to `Codable` for encoding and decoding from JSON.
/// It is used to represent a character's full profile including their current location.
///
/// - `id`: A unique identifier for the character (e.g., an integer ID).
/// - `name`: The name of the character (e.g., "Rick Sanchez").
/// - `image`: The URL of the character's image.
/// - `species`: The species of the character (e.g., "Human").
/// - `status`: The current status of the character (e.g., `alive`, `dead`, `unknown`).
/// - `gender`: The gender of the character (e.g., "Male", "Female").
/// - `location`: The location of the character, represented by a `Location` struct.
struct CharacterDetails: Codable {
  /// The unique identifier for the character.
  let id: Int

  /// The name of the character.
  let name: String

  /// The URL for the character's image.
  let image: String

  /// The species of the character (e.g., "Human", "Alien").
  let species: String

  /// The current status of the character (e.g., `alive`, `dead`, `unknown`).
  let status: CharacterStatus

  /// The gender of the character (e.g., "Male", "Female").
  let gender: String

  /// The location of the character, represented by the `Location` struct.
  let location: Location
}

// MARK: - CharacterDetails + Mocks

extension CharacterDetails {
  /// A static method to generate a mock `CharacterDetails` for testing or placeholder purposes.
  ///
  /// This method uses the `Fakery` library to generate random data for the character's details.
  ///
  /// - Returns: A mock `CharacterDetails` object with randomly generated values for `id`, `name`, `image`,
  /// `species`, `status`, `gender`, and a mock `location`.
  static func mock() -> CharacterDetails {
    let faker = Faker()
    return .init(
      id: faker.number.randomInt(),
      name: faker.name.name(),
      image: faker.internet.image(),
      species: "Human", // Default species is "Human"
      status: .alive,   // Default status is alive
      gender: faker.gender.binaryType(),
      location: .mock() // Generates a random location
    )
  }
}
