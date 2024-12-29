//
//  CharacterViewModel.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import Foundation

/// ViewModel responsible for managing the list of characters, handling status changes, loading more characters, and resetting the character list.
final class CharacterListViewModel: ObservableObject {
  // MARK: - Constants

  /// Struct to store magic numbers and reusable values.
  private struct Constants {
    /// The initial page number when fetching characters.
    static let initialPage = 0
  }

  // MARK: - Published Properties

  /// List of characters currently displayed.
  @Published
  var characters: [Character]?

  /// The current page of characters being loaded.
  @Published
  var page = 0

  /// The currently selected character status filter (alive, dead, or unknown).
  @Published
  var selectedStatus: CharacterStatus?

  /// A boolean indicating whether characters are currently being loaded.
  @Published
  var isLoading: Bool = false

  /// The error encountered during data fetching, if any.
  @Published
  var error: Error?

  // MARK: - Private Properties

  /// The service used to fetch character data.
  private let characterService: CharacterServiceInterface

  /// The task responsible for fetching characters.
  private var fetchTask: Task<Void, Never>?

  // MARK: - Initializer

  /// Initializes the view model with an optional character service.
  /// - Parameter characterService: The service used to fetch character data. Defaults to `CharacterService()`.
  init(characterService: CharacterServiceInterface = CharacterService()) {
    self.characterService = characterService
    setupStatusChangeHandling()
  }

  // MARK: - Private Methods

  /// Sets up a listener for changes in the selected character status.
  /// This ensures that the character list is reset whenever the selected status changes.
  private func setupStatusChangeHandling() {
    let statusStream = AsyncStream { continuation in
      let cancellable = $selectedStatus.sink { status in
        continuation.yield(status)
      }

      continuation.onTermination = { _ in
        cancellable.cancel()
      }
    }

    // Trigger reset of character list when the status changes.
    Task { [weak self] in
      for await _ in statusStream {
        await self?.resetCharacters()
      }
    }
  }

  // MARK: - Public Methods

  /// Loads more characters and appends them to the current list.
  /// Cancels any ongoing loading task before starting a new one.
  @MainActor
  func loadMore() {
    if isLoading { return }
    isLoading = true
    fetchTask?.cancel()

    // Create a new task to fetch more characters.
    fetchTask = Task {
      do {
        let characters = try await getCharacters()
        self.characters?.append(contentsOf: characters ?? [])
        isLoading = false
      } catch {
        self.error = error
      }
    }
  }

  /// Resets the character list and loads characters from the beginning (page 0).
  @MainActor
  func resetCharacters() {
    fetchTask?.cancel()

    // Reset the page number and fetch the initial set of characters.
    self.page = 0
    fetchTask = Task {
      do {
        isLoading = true
        let newCharacters = try await getCharacters()
        characters = newCharacters
        isLoading = false
      } catch {
        self.error = error
      }
    }
  }

  /// Fetches characters based on the current `selectedStatus` and page number.
  /// - Returns: A list of characters for the current page.
  /// - Throws: An error if the fetch operation fails.
  @MainActor
  func getCharacters() async throws -> [Character]? {
    let query = CharacterQuery(page: page + 1, status: selectedStatus)

    // Check for cancellation before proceeding with the network request.
    try Task.checkCancellation()

    // Fetch the character data from the service.
    let response = try await characterService.get(query: query)
    page = page + 1
    return response.results
  }
}
