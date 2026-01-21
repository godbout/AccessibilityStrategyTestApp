import XCTest
import AccessibilityStrategy


class ASUI_NM_gm_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asNormalMode.gm(on: $0) }
    }
    
}


// TextFields
// the macOS AX API doesn't return a proper visibleRange for TextFields which means we can't know
// what part of the text is visible or not in a TextField hence here gm behaves like gM even tho we calculate with ScreenLines.
// same issue with g0 and g$.
extension ASUI_NM_gm_Tests {
    
    func test_that_when_the_TextField_has_an_even_number_of_characters_the_move_rounds_up_and_the_block_cursor_ends_up_on_the_next_character_after_the_middle_of_the_line() {
        let textInAXFocusedElement = "yo that line should be long enough ☀️o go over the text field width hey"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gZero(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 35)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
        XCTAssertEqual(accessibilityElement.selectedText, "☀️")
    }
    
    func test_that_when_the_TextField_has_an_odd_number_of_characters_then_the_block_cursor_ends_up_right_on_the_character_in_the_middle_of_the_line() {
        let textInAXFocusedElement = "123456789 987654321 123456789 987654321"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gZero(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_if_the_TextField_is_empty_it_works_and_does_not_create_the_armageddon() {
        let textInAXFocusedElement = ""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gZero(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
    

// TextViews
extension ASUI_NM_gm_Tests {

    func test_that_for_TextViews_when_a_ScreenLine_has_an_even_number_of_characters_the_move_rounds_up_and_the_block_cursor_ends_up_on_the_next_character_after_the_middle_of_the_line() {
        let textInAXFocusedElement = """
ok so now it's gonna be even cuter
because we're having something ❤️‍🔥️ere hey
so let's gooooo brandon
"""        
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 66)
        XCTAssertEqual(accessibilityElement.selectedLength, 6)
        XCTAssertEqual(accessibilityElement.selectedText, "❤️‍🔥️")
    }

    func test_that_for_TextViews_when_a_ScreenLine_has_an_odd_number_of_characters_then_the_block_cursor_ends_up_right_on_the_character_in_the_middle_of_the_line() {
        let textInAXFocusedElement = """
ok so now it's gonna be even cuter
because we're having something here hey
so let's gooooo brandon
"""        
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 65)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }

    func test_that_for_TextViews_if_a_ScreenLine_is_empty_it_does_not_move_and_definitely_does_not_end_up_at_the_end_of_the_previous_line() {
        let textInAXFocusedElement = """
ok so now we're gonna try this and

see if it works ok?
"""        
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 35)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
    }
    
}
