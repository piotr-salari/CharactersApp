//
//  CharacterView.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI

/// View displaying a list of characters with the ability to load more and select individual characters.
struct CharacterListView: View {
  // MARK: - Constants

  /// Struct to store magic numbers and reusable values.
  private struct Constants {
    /// The horizontal padding applied to the entire view.
    static let horizontalPadding: CGFloat = 16

    /// The padding at the bottom of each character item.
    static let itemBottomPadding: CGFloat = 12
  }

  // MARK: - Properties

  /// The view model that manages the list of characters.
  @StateObject
  var viewModel: CharacterListViewModel = CharacterListViewModel()

  /// A closure that gets called when a character is selected.
  var onSelect: ((Character) -> Void)?

  // MARK: - Body

  var body: some View {
    VStack(alignment: .leading) {
      // Title for the character list
      Text("Characters")
        .font(.title)

      // Picker for selecting the status of characters
      StatusPicker(selectedStatus: $viewModel.selectedStatus)

      // Table view that displays the list of characters and allows loading more
      TableView(
        items: viewModel.characters ?? [],
        loadMore: viewModel.loadMore
      ) { character in
        // Each character item is wrapped in a CharacterItemView
        CharacterItemView(character: character)
          .padding(.bottom, Constants.itemBottomPadding)
          .onTapGesture {
            onSelect?(character) // Trigger the onSelect closure when a character is tapped
          }
      }
    }
    .padding(.horizontal, Constants.horizontalPadding)
    .task {
      // Load characters if not already loaded
      if viewModel.characters == nil {
        viewModel.resetCharacters()
      }
    }
  }
}

#Preview {
  CharacterListView(
    viewModel: CharacterListViewModel(
      characterService: CharacterServiceDouble()
    )
  )
}
