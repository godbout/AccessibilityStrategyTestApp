import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_NM_r_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(with character: Character) -> AccessibilityTextElement? {
        return applyMove(with: character) { character, focusedElement in
            asNormalMode.r(with: character, on: focusedElement)
        }
    }
}


extension ASUI_NM_r_Tests {

    // TextFields
    func test_that_in_normal_setting_it_replaces_the_character_under_the_cursor_with_the_one_given() {
        let textInAXFocusedElement = "gonna replace one of those letters..."
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.B(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "a")
      
        XCTAssertEqual(accessibilityElement?.value, "gonna replace one of thosa letters...")
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }

    func test_that_it_can_replace_a_letter_by_a_space() {
        let textInAXFocusedElement = "i need more space!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "\u{0020}")
       
        XCTAssertEqual(accessibilityElement?.value, "i need more space ")
        XCTAssertEqual(accessibilityElement?.caretLocation, 17)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
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
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "\u{000A}")

        XCTAssertEqual(accessibilityElement?.value, """
gonna replace something
b
😀️
a new line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
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

        XCTAssertEqual(accessibilityElement?.value, """
now we gonna start the replacement
move but cancel it with
escape
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 64)        
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// emojis
extension ASUI_NM_r_Tests {
    
    func test_that_it_handles_emojis() {
        let textInAXFocusedElement = """
need to deal with
e💨️💨️💨️ fac"es 🥺️☹️😂️ h😀️ha👅️" hhohohoo🤣️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "9")

        XCTAssertEqual(accessibilityElement?.value, """
need to deal with
e9💨️💨️ fac"es 🥺️☹️😂️ h😀️ha👅️" hhohohoo🤣️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 19)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}
