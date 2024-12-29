//
//  CharacterQuery.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Foundation

// MARK: - CharacterQuery

/// A struct representing a query for fetching character data.
/// - `page`: The page number for paginated results.
/// - `status`: The status of the character, such as "alive", "dead", or "unknown".
struct CharacterQuery: Hashable {
  /// The page number for paginated results.
  /// - Example: 1, 2, 3, etc.
  let page: Int
  
  /// The status of the character, optional.
  /// - Possible values: `.alive`, `.dead`, `.unknown`, or `nil`.
  let status: CharacterStatus?
}

// MARK: - CharacterQuery Query items

extension CharacterQuery {
  /// Converts the `CharacterQuery` instance to an array of `URLQueryItem`s.
  ///
  /// This function uses reflection to inspect all properties of the `CharacterQuery` struct
  /// and converts them into key-value pairs suitable for URL query parameters.
  ///
  /// - Returns: An array of `URLQueryItem`s representing the properties of the struct.
  func queryItems() -> [URLQueryItem] {
    // Create a Mirror instance to reflect on the properties of `CharacterQuery`.
    let mirror = Mirror(reflecting: self)
    
    // Initialize an empty array to store the query items.
    var queryItems: [URLQueryItem] = []
    
    // Iterate over each property of the struct using the mirror.
    for child in mirror.children {
      // Check if the child has a label (the name of the property).
      if let label = child.label {
        // Handle the value of the property.
        switch child.value {
          case Optional<Any>.none:
            // Skip properties with a `nil` value.
            continue
            
          case Optional<Any>.some(let x):
            // Append a query item with the label (property name) and its string representation.
            queryItems.append(URLQueryItem(
              name: label,
              value: String(describing: x)
            ))
            
          default:
            // Continue for any other cases (e.g., non-optional values).
            continue
        }
      }
    }
    
    // Return the array of query items.
    return queryItems
  }
}
