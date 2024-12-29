//
//  CharacterDetailsViewModel.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI

/// ViewModel responsible for managing the state and business logic for the `CharacterDetailsView`.
/// This view model fetches and holds detailed information about a character, including their name, image, status, species, gender, and location.
final class CharacterDetailsViewModel: ObservableObject {
  /// The unique identifier for the character.
  @Published
  var id: Int

  /// The URL of the character's image.
  @Published
  var image: String

  /// The name of the character.
  @Published
  var name: String

  /// The status of the character (e.g., alive, dead, unknown).
  @Published
  var status: CharacterStatus

  /// The species of the character (e.g., human, alien).
  @Published
  var species: String

  /// The gender of the character (optional).
  @Published
  var gender: String?

  /// The location of the character (optional).
  @Published
  var location: String?

  /// The service used to fetch character data.
  let characterService: CharacterServiceInterface

  /// Initializes a new `CharacterDetailsViewModel` with the provided character and character service.
  /// - Parameters:
  ///   - character: A `Character` object containing initial data for the view model.
  ///   - characterService: An object conforming to `ICharacterService` used for fetching character details. Defaults to a `CharacterService`.
  init(
    _ character: Character,
    characterService: CharacterServiceInterface = CharacterService()
  ) {
    self.id = character.id
    self.image = character.image
    self.name = character.name
    self.status = character.status
    self.species = character.species
    self.characterService = characterService
  }

  /// Asynchronously fetches the detailed information of a character using the provided character ID.
  /// This method updates the view model's properties with the fetched data.
  /// - Parameter id: The unique identifier for the character to fetch details for.
  /// - Throws: An error if the network request fails or if the data is invalid.
  @MainActor
  func setCharacterDetails(id: Int) async {
    do {
      // Fetch character details from the service
      let character = try await characterService.get(
        id: String(describing: id)
      )
      // Update the view model properties with fetched data
      self.image = character.image
      self.name = character.name
      self.status = character.status
      self.species = character.species
      self.gender = character.gender
      self.location = character.location.name
    } catch {
      // TODO: - Log the error if the data fetch fails
      debugPrint(error)
    }
  }
}
