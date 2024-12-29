//
//  Character.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Fakery
import Foundation

/// A struct representing a character in the system.
///
/// This struct contains basic properties of a character, such as an ID, name, species, status, and an image URL.
/// It conforms to `Codable`, `Identifiable`, and `Hashable` to be easily used in lists, encoded/decoded from JSON, and
/// identified uniquely.
///
/// - `id`: A unique identifier for the character (e.g., an integer ID).
/// - `name`: The name of the character (e.g., "Rick Sanchez").
/// - `image`: The URL of the character's image.
/// - `species`: The species of the character (e.g., "Human", "Alien").
/// - `status`: The current status of the character (e.g., `alive`, `dead`, `unknown`).
struct Character: Codable, Identifiable, Hashable {
  /// The unique identifier for this character.
  let id: Int

  /// The name of the character.
  let name: String

  /// The URL of the character's image.
  let image: String

  /// The species of the character.
  let species: String

  /// The current status of the character (e.g., `alive`, `dead`, `unknown`).
  let status: CharacterStatus
}

// MARK: - Character + Mocks

extension Character {
  /// A static method to generate a mock character for testing purposes.
  ///
  /// This method uses the `Fakery` library to generate random data for the character. The `status` parameter allows
  /// specifying the character's status, with `.alive` as the default value.
  ///
  /// - Parameter status: The status of the character (default is `.alive`).
  /// - Returns: A mock `Character` with random values for `id`, `name`, `image`, and `species`, and the provided `status`.
  static func mock(status: CharacterStatus = .alive) -> Character {
    let faker = Faker()
    return Character(
      id: faker.number.randomInt(),
      name: faker.name.name(),
      image: faker.internet.image(width: 200, height: 200),
      species: "Human", // Default species is "Human"
      status: status
    )
  }

  /// A static method to generate a list of mock characters.
  ///
  /// This method generates an array of mock characters using the `mock(status:)` method. The number of characters
  /// generated is determined by the `count` parameter.
  ///
  /// - Parameter count: The number of characters to generate (default is 3).
  /// - Returns: An array of `count` mock `Character` objects.
  static func mocks(count: Int = 3) -> [Character] {
    var list: [Character] = []
    for _ in 0..<count {
      list.append(Character.mock())
    }
    return list
  }
}
