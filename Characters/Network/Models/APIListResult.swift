//
//  APIResult.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Foundation

/// A generic struct representing a paginated list of results returned from an API.
///
/// This struct is used to represent the response when fetching a list of items from an API. It contains two main properties:
/// - `info`: Information about the pagination (e.g., total count, number of pages).
/// - `results`: The actual list of items returned by the API. The type of `results` is generic (`T`), which must conform to `Codable` and be a `Collection` (e.g., `Array`, `Set`).
///
/// The `mock` function allows generating a mock `ApiListResult` with predefined data, useful for testing purposes.
///
/// - `T`: The type of the collection (e.g., `Array<Character>`).
struct APIListResult<T>: Codable where T: Codable & Collection {
  /// Pagination info about the result.
  let info: APIInfo

  /// The actual list of results returned by the API.
  let results: T

  /// A static method to create a mock `ApiListResult` instance for testing or placeholder data.
  ///
  /// - Parameter value: The collection of mock data that will be assigned to the `results` property.
  /// - Returns: An `ApiListResult` instance containing the provided `value` as `results` and generated `info`.
  static func mock(value: T) -> APIListResult<T> {
    .init(info: .mock(count: value.count), results: value)
  }
}
