//
//  APIInfo.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Foundation

/// A struct representing the pagination information returned from an API.
///
/// This struct contains metadata about the paginated response, such as:
/// - `count`: The total number of results available across all pages.
/// - `pages`: The total number of pages in the result set.
/// - `next`: The URL of the next page (if any).
/// - `prev`: The URL of the previous page (if any).
///
/// The `mock` function generates mock `APIInfo` data, useful for testing or when placeholder data is needed.
///
/// - `count`: The total number of results (e.g., the total number of characters).
/// - `pages`: The number of pages available based on the `count` and page size.
/// - `next`: The URL of the next page of results, or `nil` if no more pages are available.
/// - `prev`: The URL of the previous page of results, or `nil` if on the first page.
struct APIInfo: Codable {
  /// The total number of results available across all pages.
  let count: Int

  /// The total number of pages available.
  let pages: Int

  /// The URL for the next page of results, or `nil` if no more pages are available.
  let next: String?

  /// The URL for the previous page of results, or `nil` if on the first page.
  let prev: String?

  /// A static method to generate mock `APIInfo` data for testing or placeholder purposes.
  ///
  /// - Parameter count: The total number of items in the dataset. This is used to generate `count` and `pages`.
  /// - Returns: A mock `APIInfo` instance with `count`, `pages` (set to 1 for simplicity), and empty `next` and `prev` URLs.
  static func mock(count: Int) -> APIInfo {
    .init(count: count, pages: 1, next: "", prev: "")
  }
}

