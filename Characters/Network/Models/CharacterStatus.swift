//
//  CharacterStatus.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Foundation

/// An enum representing the status of a character.
///
/// This enum represents the possible states of a character, such as alive, dead, or unknown.
/// It conforms to `String`, `Codable`, `CaseIterable`, and `Identifiable` for ease of use with lists and APIs.
///
/// - `alive`: The character is alive.
/// - `dead`: The character is deceased.
/// - `unknown`: The character's status is unknown.
///
/// The `id` computed property returns the raw value of the status, which is a string.
enum CharacterStatus: String, CaseIterable, Codable, Identifiable {
  /// The character is alive.
  case alive = "Alive"

  /// The character is dead.
  case dead = "Dead"

  /// The character's status is unknown.
  case unknown = "unknown"

  /// A computed property that returns the raw string value of the `CharacterStatus`.
  var id: String {
    rawValue
  }
}
