import XCTest
@testable import AccessibilityStrategy
import VimEngineState


class ASUI_NM_r_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, with character: Character, pgR: Bool = false) -> AccessibilityTextElement {
        return applyMove { asNormalMode.r(times: count, with: character, on: $0, VimEngineState(pgR: pgR)) }
    }
    
}


// count
extension ASUI_NM_r_Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = "we goNNa moVe in tHere with count 🈹️ awww"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "g", on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 10, with: "z")
        
        XCTAssertEqual(accessibilityElement.fileText.value, "we zzzzzzzzzz in tHere with count 🈹️ awww")
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "z")
    }
    
    // if replacement is a linefeed, count is ignored in Vim. but still, the move shouldn't work. count has precedence
    // over the replacement itself.
    func test_that_if_the_count_is_so_high_that_it_goes_over_the_FileLine_end_it_does_nothing_and_that_includes_if_the_replacement_is_a_linefeed() {
        let textInAXFocusedElement = """
we goNNa moVe in tHere with count awww
and one more line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        let accessibilityElement = applyMoveBeingTested(times: 36, with: "\n")

        XCTAssertEqual(accessibilityElement.fileText.value, """
we goNNa moVe in tHere with count awww
and one more line
"""
)
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "g")
    }
    
}


// both
extension ASUI_NM_r_Tests {

    func test_that_in_normal_setting_it_replaces_the_character_under_the_cursor_with_the_one_given() {
        let textInAXFocusedElement = "gonna replace one of those letters..."
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.B(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "a")
      
        XCTAssertEqual(accessibilityElement.fileText.value, "gonna replace one of thosa letters...")
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

    func test_that_it_can_replace_a_letter_by_a_space() {
        let textInAXFocusedElement = "i need more space!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "\u{0020}")
       
        XCTAssertEqual(accessibilityElement.fileText.value, "i need more space ")
        XCTAssertEqual(accessibilityElement.caretLocation, 17)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// TextViews
extension ASUI_NM_r_Tests {
    
    func test_that_replacing_a_character_by_a_linefeed_sets_the_cursor_at_the_first_column_of_the_new_created_line() {
        let textInAXFocusedElement = """
gonna replace something
by😀️
a new line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "\u{000A}")

        XCTAssertEqual(accessibilityElement.fileText.value, """
gonna replace something
b
😀️
a new line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_cancelling_the_replacement_by_giving_escape_does_not_move_the_caret_backwards() {
        let textInAXFocusedElement = """
now we gonna start the replacement
move but cancel it with
escape
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "\u{001B}")

        XCTAssertEqual(accessibilityElement.fileText.value, """
now we gonna start the replacement
move but cancel it with
escape
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 64)        
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR
extension ASUI_NM_r_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "gonna replace one of those letters..."
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.B(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "a", pgR: true)
      
        XCTAssertEqual(accessibilityElement.fileText.value, "gonna replace one of thosa letters...")
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "a")
    }
    
}
