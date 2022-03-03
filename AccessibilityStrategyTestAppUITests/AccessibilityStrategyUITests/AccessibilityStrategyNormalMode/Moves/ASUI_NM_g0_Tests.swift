import XCTest
import AccessibilityStrategy


// see g^ for blah blah
class ASUI_NM_g0_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asNormalMode.gZero(on: $0) }
    }
    
}


// Both
extension ASUI_NM_g0_Tests {
    
    func test_that_in_normal_setting_it_moves_the_caret_position_to_the_first_character_of_the_line() {
        let textInAXFocusedElement = "g0 should send us to the beginning of the screen line"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 49)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "l")
    }   
    
}
    

// TextViews
extension ASUI_NM_g0_Tests {
    
    func test_that_at_the_beginning_of_a_line_zero_does_not_move() {
        let textInAXFocusedElement = """
multiline
where we gonna test g0
and again this is for screen lines 😀️y friend so this line is long!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 80)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "s")
    }

}
