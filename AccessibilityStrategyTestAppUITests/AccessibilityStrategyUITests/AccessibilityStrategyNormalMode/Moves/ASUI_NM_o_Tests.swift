import XCTest
import KeyCombination
import AccessibilityStrategy


// the tests for word wrap have to be done here in UI because we have to reposition
// the caret between the two linefeeds AFTER the move is done.
class ASUI_NM_o_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.o(on: $0) }
    }
    
}



extension ASUI_NM_o_Tests {
   
    func test_that_if_a_line_does_not_end_with_a_linefeed_and_it_is_not_the_last_line_then_it_does_insert_two_linefeeds_and_reposition_the_caret_between_them() {
        let textInAXFocusedElement = """
that's 😀️ a multiline 😀️😀️ and a long 😀️😀️ one that will be wrapped somewhere but we 😀️ don't know where LOL and i have to 😀️ test that shit
"""

        
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.k(on: $0) }        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
that's 😀️ a multiline 😀️😀️ and a long 😀️😀️ one that will be wrapped somewhere but we 😀️ don't know where LOL and i 

have to 😀️ test that shit
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 122)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_if_a_line_does_not_end_with_a_linefeed_but_is_the_last_line_then_it_works_normally_and_only_inserts_one_linefeed() {
        let textInAXFocusedElement = """
that's 😀️ a multiline 😀️😀️ and a long 😀️😀️ one that will be wrapped somewhere but we 😀️ don't know where LOL and i have to 😀️ test that shit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.text.value, """
that's 😀️ a multiline 😀️😀️ and a long 😀️😀️ one that will be wrapped somewhere but we 😀️ don't know where LOL and i have to 😀️ test that shit

"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 148)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
}
