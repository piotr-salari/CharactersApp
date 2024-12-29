//
//  UITableViewCell.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI
import UIKit

/// A generic table view cell that hosts a SwiftUI view inside a `UITableViewCell`.
/// This class allows you to display a SwiftUI view inside a table view cell in a UIKit-based `UITableView`.
///
/// - `Content`: The type of the SwiftUI view that will be hosted in the cell. This is a generic type constrained to `View`.
final class TableViewCell<Content: View>: UITableViewCell {
  // MARK: - Properties
  
  /// The hosting controller that wraps the SwiftUI view.
  private var hostingController: UIHostingController<Content>?

  // MARK: - Methods

  /// Configures the cell with a SwiftUI view.
  ///
  /// This method removes any previously added hosting controller and its view, creates a new `UIHostingController` with the given SwiftUI view, and adds it to the cell's `contentView`. Constraints are applied to make sure the SwiftUI view fills the entire cell.
  ///
  /// - Parameter view: The SwiftUI view to be displayed inside the table view cell.
  func configure(with view: Content) {
    // Remove previous hosting controller's view and clean up
    hostingController?.view.removeFromSuperview()
    hostingController?.removeFromParent()

    // Create a new hosting controller with the provided SwiftUI view
    let hostingController = UIHostingController(rootView: view)
    self.hostingController = hostingController

    // Add the hosting controller's view to the cell's content view
    contentView.addSubview(hostingController.view)

    // Set up Auto Layout constraints to make the SwiftUI view fill the cell's content view
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
