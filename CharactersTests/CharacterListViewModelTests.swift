//
//  CharacterListViewModelTests.swift
//  CharactersApp Tests
//
//  Created by Piotr Salari on 10/11/2024.
//

import Testing
import XCTest

@testable import Characters

final class CharacterListViewModelTests: XCTestCase {
    private var viewModel: CharacterListViewModel!

  private var characterService: CharacterServiceDouble!

    override func setUp() {
        super.setUp()
        // Initialize the view model and mock service before each test
        characterService = CharacterServiceDouble()
        viewModel = CharacterListViewModel(characterService: characterService)
    }

    override func tearDown() {
        // Clean up resources after each test
        viewModel = nil
        characterService = nil
        super.tearDown()
    }

    // MARK: - Test Case 1: Initial State

    /// Tests the initial state of the view model after initialization.
    func testInitialState() async throws {
        XCTAssertNil(viewModel.characters, "Characters should be nil initially.")
        XCTAssertEqual(viewModel.page, 0, "Page should be 0 initially.")
        XCTAssertNil(viewModel.selectedStatus, "Selected status should be nil initially.")
    }

    // MARK: - Test Case 2: Load More Characters

    /// Tests the loadMore function to ensure it loads more characters and increments the page.
    func testLoadMoreCharacters() async throws {
        let mockCharacters = Character.mocks(count: 6)
        characterService.mockCharacters = mockCharacters

        XCTAssertEqual(viewModel.page, 1, "Page should be 1 before loading more characters.")

        await viewModel.loadMore()

        XCTAssertEqual(viewModel.characters?.count, 3, "Characters count should be 3 after loading more.")
        XCTAssertEqual(viewModel.page, 1, "Page should be incremented to 1 after loading more characters.")
    }
}
