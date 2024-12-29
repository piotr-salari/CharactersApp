//
//  StatusPicker.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI

/// A view that allows the user to select a character status from a list.
/// It displays buttons for each status (alive, dead, unknown) and updates the `selectedStatus` binding accordingly.
struct StatusPicker: View {
  // MARK: - Constants

  /// Struct to store magic numbers and reusable values.
  private struct Constants {
    /// Horizontal padding for status buttons.
    static let horizontalPadding: CGFloat = 12

    /// Vertical padding for status buttons.
    static let verticalPadding: CGFloat = 8

    /// Corner radius for the status button background.
    static let cornerRadius: CGFloat = 24

    /// Line width for the stroke around unselected status buttons.
    static let strokeLineWidth: CGFloat = 1
  }

  // MARK: - Properties

  /// The binding to the selected status of the character.
  @Binding
  var selectedStatus: CharacterStatus?

  /// The list of all possible character statuses.
  let statusList = CharacterStatus.allCases

  // MARK: - Body

  var body: some View {
    HStack {
      // Iterate over each status and create a button for it.
      ForEach(statusList) { status in
        Button {
          // Toggle the selected status when the button is tapped.
          if selectedStatus == status {
            selectedStatus = nil
          } else {
            selectedStatus = status
          }
        } label: {
          // Text label for the status button.
          Text(status.rawValue)
            .foregroundColor(.black)
            .font(.subheadline)
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding)
            .background {
              // Background styling based on the selected status.
              if status == selectedStatus {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                  .fill(.gray.opacity(0.35))
              } else {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                  .stroke(.gray, lineWidth: Constants.strokeLineWidth)
              }
            }
        }
      }
    }
  }
}

#Preview {
  @Previewable @State
  var selectedStatus: CharacterStatus? = .alive

  StatusPicker(selectedStatus: $selectedStatus)
}
