import XCTest
import KeyCombination
import AccessibilityStrategy


class UIASNM_x_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.x(on: $0) }
    }
    
}


// Both
extension UIASNM_x_Tests {
    
    func test_that_in_normal_setting_it_deletes_the_character_after_the_caret_location() {
        let textInAXFocusedElement = "x should delete the right character"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.value, "x should delete the right haracter")
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// TextViews
extension UIASNM_x_Tests {

    func test_that_if_the_caret_is_at_the_last_character_of_a_line_that_does_not_end_with_a_linefeed_it_deletes_the_last_character_and_goes_back_one_character() {
        let textInAXFocusedElement = """
so we're on the last
character of the last line
that is not an empty line🤡️🤡️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
      
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.value, """
so we're on the last
character of the last line
that is not an empty line🤡️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 73)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_if_the_caret_is_on_an_empty_line_it_does_not_delete_the_linefeed() {
        let textInAXFocusedElement = """
next line is gonna be empty!

but shouldn't be deleted
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.value, """
next line is gonna be empty!

but shouldn't be deleted
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 29)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_if_it_deletes_the_last_standing_character_of_a_line_it_does_not_jump_to_the_previous_line() {
        let textInAXFocusedElement = """
shouldn't jump up on this line!
☀️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.value, """
shouldn't jump up on this line!

"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 32)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_it_should_not_suck_the_next_line() {
        let textInAXFocusedElement = """
💥️
x
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.value, """

x
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
}


// emojis
extension UIASNM_x_Tests {
    
    func test_that_it_can_delete_a_character_and_end_up_on_the_following_emoji_correctly() {
        let textInAXFocusedElement = """
need to deal with
those💨️💨️💨️ fac"es 🥺️☹️😂️ 😀️😀️ha👅️" hhohohoo🤣️
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.value, """
need to deal with
those💨️💨️ fac"es 🥺️☹️😂️ 😀️😀️ha👅️" hhohohoo🤣️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 23)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}
