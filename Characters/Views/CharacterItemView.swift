//
//  CharacterView.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI

import SwiftUI

/// View representing an individual character item in a list.
/// Displays the character's image, name, species, and status in a horizontal stack.
struct CharacterItemView: View {
  // MARK: - Constants

  /// Constants struct to store magic numbers and reusable values.
  private struct Constants {
    /// The size (width and height) for character images.
    static let imageSize: CGFloat = 75

    /// The corner radius for the character images and backgrounds.
    static let imageCornerRadius: CGFloat = 12

    static let backgroundCornerRadius: CGFloat = 12

    /// The vertical padding for text in the character item.
    static let textTopPadding: CGFloat = 4

    /// The height of each row in the list.
    static let rowHeight: CGFloat = 108

    /// The line width for the stroke around the unknown status background.
    static let strokeLineWidth: CGFloat = 1
  }

  // MARK: - Properties

  /// The character to display in the item view.
  var character: Character

  // MARK: - Body

  var body: some View {
    HStack {
      // Display character image with rounded corners and a fixed size
      AsyncImage(url: URL(string: character.image)) { image in
        image
          .resizable()
          .frame(width: Constants.imageSize, height: Constants.imageSize)
          .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
      } placeholder: {
        // Placeholder image if the character image is not available
        Image(systemName: "person")
          .resizable()
          .frame(width: Constants.imageSize, height: Constants.imageSize)
          .background(Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
      }

      VStack(alignment: .leading) {
        // Display character's name with bold title font
        Text(character.name)
          .font(.title2)
          .fontWeight(.bold)

        // Display character's species with reduced opacity
        Text(character.species)
          .opacity(0.8)

        Spacer()
      }
      .padding(.top, Constants.textTopPadding)

      Spacer()
    }
    .padding()
    .frame(height: Constants.rowHeight)
    .background(alignment: .center) {
      // Background color based on character's status
      background(status: character.status)
    }
  }
}

// MARK: - Helper Methods

extension CharacterItemView {
  /// ViewBuilder to set the background color based on the character's status.
  /// - Parameter status: The status of the character (alive, dead, unknown).
  /// - Returns: A view displaying the background color or stroke based on the status.
  @ViewBuilder
  func background(status: CharacterStatus) -> some View {
    switch status {
      case .alive:
        Color("alive")
          .cornerRadius(Constants.backgroundCornerRadius)
      case .dead:
        Color("dead")
          .opacity(0.5)
          .cornerRadius(Constants.backgroundCornerRadius)
      case .unknown:
        RoundedRectangle(cornerRadius: Constants.backgroundCornerRadius)
          .stroke(.gray, lineWidth: Constants.strokeLineWidth)
    }
  }
}

#Preview {
  VStack {
    CharacterItemView(character: .mock(status: .alive))
    CharacterItemView(character: .mock(status: .dead))
    CharacterItemView(character: .mock(status: .unknown))
  }
  .padding(.horizontal)
}
