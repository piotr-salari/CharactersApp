//
//  TableVIew.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI
import UIKit

/// A SwiftUI `UIViewRepresentable` component for displaying a list of items in a `UITableView`.
/// This component integrates a `UITableView` with SwiftUI and supports dynamic row loading with the ability to trigger
/// a "load more" action when the user scrolls near the end of the list.
///
/// - `items`: The array of `Character` objects to display in the table view.
/// - `threshold`: The number of rows from the end of the list to trigger the `loadMore` closure (default is 5).
/// - `loadMore`: A closure that is called when the user scrolls near the end of the table view (to load more data).
/// - `content`: A closure that returns the content view for each table cell, which takes a `Character` object as input.
///
/// This component is highly customizable and works well for scenarios like paginated data or long lists.
public struct TableView<Content: View>: UIViewRepresentable {
  // MARK: - Properties

  /// The items to display in the table view.
  let items: [Character]

  /// The number of rows from the end of the list to trigger the load more action (default is 5).
  let threshold: Int = 5

  /// A closure that is called when the user scrolls near the end of the list, to load more data.
  let loadMore: (() -> Void)?

  /// A closure that generates the content view for each cell, based on the `Character` object.
  let content: (Character) -> Content

  // MARK: - UIViewRepresentable Methods

  /// Creates and configures the `UITableView` instance.
  /// - Parameter context: The context object that holds the current state of the `UIViewRepresentable`.
  /// - Returns: A configured `UITableView` object.
  public func makeUIView(context: Context) -> UIViewType {
    let tableView = UITableView()
    tableView.dataSource = context.coordinator
    tableView.delegate = context.coordinator
    tableView.register(TableViewCell<Content>.self, forCellReuseIdentifier: "TableViewCell")
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }

  /// Updates the `UITableView` when the SwiftUI state changes.
  /// - Parameters:
  ///   - uiView: The `UITableView` instance to update.
  ///   - context: The context object that holds the current state of the `UIViewRepresentable`.
  public func updateUIView(_ uiView: UITableView, context: Context) {
    context.coordinator.parent = self
    uiView.reloadData()
  }

  /// Creates the coordinator that manages the table view's data and actions.
  /// - Returns: A new `Coordinator` instance.
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  // MARK: - Coordinator Class

  /// The coordinator is responsible for managing the table view's data source and delegate methods.
  /// It interacts with the parent `TableView` to configure and update the table view.
  public class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
    var parent: TableView

    init(_ parent: TableView) {
      self.parent = parent
    }

    // MARK: - UITableViewDataSource Methods

    /// Returns the number of rows in the given section.
    /// - Parameter tableView: The `UITableView` instance.
    /// - Parameter section: The section index (only one section is supported).
    /// - Returns: The number of rows in the section.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      parent.items.count
    }

    /// Returns the cell for the given index path.
    /// - Parameter tableView: The `UITableView` instance.
    /// - Parameter indexPath: The index path of the cell.
    /// - Returns: A configured `UITableViewCell` for the given index path.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell<Content> else {
        return UITableViewCell()
      }

      let item = parent.items[indexPath.row]
      cell.configure(with: parent.content(item))
      
      // Check if more items should be loaded when scrolling near the end
      if indexPath.row >= parent.items.count - parent.threshold {
        parent.loadMore?()
      }

      return cell
    }

    // MARK: - UITableViewDelegate Methods

    /// Returns the height for a row at a specific index path.
    /// - Parameter tableView: The `UITableView` instance.
    /// - Parameter indexPath: The index path of the row.
    /// - Returns: The height for the row at the given index path.
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      UITableView.automaticDimension
    }
  }
}
