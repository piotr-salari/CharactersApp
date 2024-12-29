//
//  ContentView.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI

/// The main view of the app which displays a list of characters.
/// It handles the navigation to a detailed view of the selected character.
struct ContentView: View {
  // MARK: - Constants

  /// Struct to store reusable constants.
  private struct Constants {
    /// The initial navigation path (empty by default).
    static let initialPath = NavigationPath()
  }

  // MARK: - Properties

  /// The character service used to fetch character data.
  var characterService: CharacterServiceInterface = CharacterService()

  /// The navigation path to manage the navigation stack.
  @State
  private var path = NavigationPath()

  // MARK: - Body

  var body: some View {
    NavigationStack(path: $path) {
      // CharacterListView displays a list of characters
      CharacterListView { character in
        // When a character is selected, navigate to the character details view
        path.append(character)
      }
      .navigationDestination(for: Character.self) { character in
        // CharacterDetailsView shows detailed information about the selected character
        CharacterDetailsView(
          viewModel: CharacterDetailsViewModel(character)
        )
      }
    }
  }
}

#Preview {
  ContentView(characterService: CharacterServiceDouble())
}
