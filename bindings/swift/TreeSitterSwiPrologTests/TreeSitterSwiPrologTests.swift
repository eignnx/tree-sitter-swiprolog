import XCTest
import SwiftTreeSitter
import TreeSitterSwiprolog

final class TreeSitterSwiprologTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_swiprolog())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading SWI Prolog grammar")
    }
}
