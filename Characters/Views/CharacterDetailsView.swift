//
//  CharacterDetailsView.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI

/// A view that displays detailed information about a character, including the character's image, name, status, species, gender, and location.
struct CharacterDetailsView: View {
  // MARK: - Constants

  /// A private struct containing constant values for UI layout, dimensions, and styling.
  private struct Constants {
    /// Height for the character image.
    static let imageHeight: CGFloat = 350

    /// Corner radius value used in various UI elements.
    static let cornerRadius: CGFloat = 30

    /// Horizontal padding for the status label.
    static let statusPaddingHorizontal: CGFloat = 8

    /// Vertical padding for the status label.
    static let statusPaddingVertical: CGFloat = 4

    /// Top padding for the location section.
    static let locationPaddingTop: CGFloat = 12

    /// Top padding for the character details section.
    static let detailsPaddingTop: CGFloat = 16

    /// Size of the back button icon.
    static let backButtonSize: CGFloat = 50

    /// X position of the back button.
    static let backButtonPositionX: CGFloat = 42

    /// Y position of the back button.
    static let backButtonPositionY: CGFloat = 16

    /// Line width used for the border of the unknown status background.
    static let strokeLineWidth: CGFloat = 1
  }

  // MARK: - Properties

  /// The view model responsible for managing the state and business logic for the character details view.
  /// This view model is observed to update the view whenever its data changes.
  @ObservedObject
  var viewModel: CharacterDetailsViewModel

  /// A SwiftUI environment value that provides access to the current view's dismiss action.
  /// Used here to allow the user to dismiss the current view and navigate back.
  @Environment(\.dismiss)
  var dismiss

  // MARK: - Body

  /// The body of the view, which contains a scrollable vertical stack of content.
  /// Displays the character's image, name, status, species, gender, and location.
  var body: some View {
    ScrollView {
      VStack {
        // Display character image with a dynamic AsyncImage
        AsyncImage(url: URL(string: viewModel.image)) { image in
          image
            .resizable()
            .frame(height: Constants.imageHeight)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(Constants.cornerRadius)
        } placeholder: {
          Image(systemName: "person")
            .resizable()
            .frame(height: Constants.imageHeight)
            .aspectRatio(contentMode: .fill)
            .background(Color.gray)
            .cornerRadius(Constants.cornerRadius)
        }

        // Character details section
        detailsSection
      }
    }
    .ignoresSafeArea()
    .navigationBarBackButtonHidden(true)
    .overlay {
      // Custom back button overlay
      Image(systemName: "arrow.backward")
        .frame(width: Constants.backButtonSize, height: Constants.backButtonSize)
        .background {
          Color.white
            .clipShape(Circle())
        }
        .onTapGesture {
          dismiss()
        }
        .position(x: Constants.backButtonPositionX, y: Constants.backButtonPositionY)
    }
    .task {
      // Fetch character details when the view appears
      await viewModel.setCharacterDetails(id: viewModel.id)
    }
  }

  private var detailsSection: some View {
    // Character details section
    VStack(alignment: .leading) {
      HStack {
        // Character's name and status
        Text(viewModel.name)
          .font(.title)
        Spacer()
        Text(viewModel.status.rawValue)
          .font(.subheadline)
          .padding(.horizontal, Constants.statusPaddingHorizontal)
          .padding(.vertical, Constants.statusPaddingVertical)
          .background {
            background(status: viewModel.status)
          }
      }

      // Species and gender
      Text("\(viewModel.species) . \(viewModel.gender ?? "")")
        .redacted(reason: viewModel.gender == nil ? .placeholder : [])

      // Location section
      HStack {
        Text("Location:")
        Text(viewModel.location ?? "")
      }
      .redacted(reason: viewModel.location == nil ? .placeholder : [])
      .padding(.top, Constants.locationPaddingTop)
    }
    .padding(.horizontal)
    .padding(.top, Constants.detailsPaddingTop)
  }

  // MARK: - Helper Methods

  /// A helper method to determine the background color for the character's status.
  /// - Parameter status: The character's current status.
  /// - Returns: A background view that visually represents the character's status.
  @ViewBuilder
  func background(status: CharacterStatus) -> some View {
    switch status {
      case .alive:
        Color("alive")
          .cornerRadius(Constants.cornerRadius)

      case .dead:
        Color("dead")
          .opacity(0.5)
          .cornerRadius(Constants.cornerRadius)

      case .unknown:
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
          .stroke(.gray, lineWidth: Constants.strokeLineWidth)
    }
  }
}

#Preview {
  CharacterDetailsView(
    viewModel: CharacterDetailsViewModel(
      Character.mock(),
      characterService: CharacterServiceDouble()
    )
  )
}
