//
//  URLSession+Extensions.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Foundation

/// A struct representing the error response from the API, used to decode the error message.
///
/// This DTO (Data Transfer Object) is used to decode the error response from the Rick and Morty API
/// when a client-side (4xx) error occurs. It contains an array of error messages, an error type, and a status code.
///
/// - `message`: A list of error messages returned by the API.
/// - `error`: A string describing the type of error (e.g., "Invalid Request").
struct CustomErrorDto: Codable {
  /// A list of error messages returned by the API.
  let message: [String]

  /// A string describing the type of error (e.g., "Invalid Request").
  let error: String

  /// The HTTP status code of the response.
  let statusCode: Int
}

extension URLSession {
  /// HTTP methods supported for making requests (GET, POST, PUT, DELETE).
  ///
  /// This enum encapsulates the different HTTP methods used for making network requests.
  /// - `get`: Used for retrieving resources.
  /// - `post`: Used for creating new resources.
  /// - `put`: Used for updating resources.
  /// - `delete`: Used for deleting resources.
  public enum HttpMethod: String {
    /// The HTTP GET method used to retrieve resources from the server.
    case get = "GET"

    /// The HTTP POST method used to send data to the server to create or update resources.
    case post = "POST"

    /// The HTTP PUT method used to update or replace a resource on the server.
    case put = "PUT"

    /// The HTTP DELETE method used to remove a resource from the server.
    case delete = "DELETE"
  }

  /// Error types related to API requests.
  ///
  /// This enum categorizes errors that can occur during API requests.
  /// - `clientError`: Represents errors on the client-side (4xx HTTP status codes).
  /// - `networkError`: Represents errors occurring during the network request (e.g., no internet).
  /// - `invalidResponse`: Represents an invalid HTTP response (not a valid HTTP URL response).
  /// - `invalidURL`: Represents an invalid URL.
  /// - `invalidData`: Represents a situation where the received data cannot be decoded.
  /// - `serverError`: Represents errors on the server-side (5xx HTTP status codes).
  public enum APIError: Error {
    /// Client-side error (4xx status code). Contains a description of the error message.
    case clientError(String)

    /// Network error (e.g., no internet connection or DNS issues). Contains the underlying `Error`.
    case networkError(Error)

    /// Invalid response from the server (not an HTTP URL response).
    case invalidResponse

    /// Invalid or malformed URL.
    case invalidURL

    /// Data received from the server could not be decoded into the expected model.
    case invalidData

    /// Server-side error (5xx status code). Contains the HTTP status code returned from the server.
    case serverError(statusCode: Int)
  }

  /// A generic method for making API requests to the Rick and Morty API.
  ///
  /// This function sends an asynchronous network request to a specified API endpoint, handles the response,
  /// and decodes the returned data into a model of type `T`, which conforms to `Codable`.
  ///
  /// - Parameters:
  ///   - path: The API endpoint to request (e.g., `.character`).
  ///   - id: An optional string representing the ID of the resource to fetch. This is used for endpoints like `/character/{id}`.
  ///   - httpMethod: The HTTP method to use (e.g., GET, POST, PUT, DELETE).
  ///   - body: The body of the request, if needed (e.g., for POST or PUT requests).
  ///   - queryItems: An array of `URLQueryItem`s to append as query parameters to the URL.
  /// - Returns: An object of type `T` decoded from the response data.
  /// - Throws: An error if the request fails (e.g., invalid response, client-side error, or server-side error).
  public func request<T: Codable>(
    path: RickAndMortyAPIs,
    id: String? = nil,
    httpMethod: HttpMethod,
    body: Data? = nil,
    queryItems: [URLQueryItem] = []
  ) async throws -> T {
    // Construct the full URL for the request, combining the base URL, path, optional ID, and query parameters.
    var url = RickAndMortyAPIs.baseURL.appending(path: path.rawValue)
    
    if let id = id {
      url = url.appending(path: "/\(id)")
    }
    url = url.appending(queryItems: queryItems)

    // Create a URLRequest and configure it with HTTP method, headers, and body (if provided).
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = httpMethod.rawValue
    urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
    urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
    if let body = body {
      urlRequest.httpBody = body
    }

    // Perform the request and retrieve the response data.
    let (data, urlResponse) = try await data(for: urlRequest)

    // Handle the response status code and throw relevant errors if necessary.
    try manageHttpResponse(urlResponse, data: data)

    // Decode the response data into the specified type `T`.
    let result = try JSONDecoder().decode(T.self, from: data)

    return result
  }

  /// Handles the HTTP response status code and throws appropriate errors based on the status.
  ///
  /// - Parameters:
  ///   - urlResponse: The response from the server.
  ///   - data: The raw data returned from the server.
  /// - Throws: An error if the response is not valid or the status code indicates an error.
  func manageHttpResponse(_ urlResponse: URLResponse, data: Data) throws {
    // Ensure the response is an HTTP response.
    guard let httpResponse = urlResponse as? HTTPURLResponse else {
      throw APIError.invalidResponse
    }

    // Extract the status code from the HTTP response.
    let statusCode = httpResponse.statusCode

    // Handle different ranges of status codes.
    switch statusCode {
      case 200...299:
        // Success range (2xx status codes) - no error, continue processing.
        return

      case 400...499:
        // Client error range (4xx status codes) - decode and throw the error message.
        let errorMessage = try JSONDecoder().decode(CustomErrorDto.self, from: data)
        let firstMessage = errorMessage.message.first ?? "No error message found"
        throw APIError.clientError(firstMessage)

      case 500...599:
        // Server error range (5xx status codes).
        throw APIError.serverError(statusCode: statusCode)

      default:
        // Any other unexpected status code.
        throw APIError.invalidResponse
    }
  }
}

