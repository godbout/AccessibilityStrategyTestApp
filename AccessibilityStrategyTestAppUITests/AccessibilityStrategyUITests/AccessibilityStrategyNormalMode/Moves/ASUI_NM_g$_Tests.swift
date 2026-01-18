import XCTest
import AccessibilityStrategy


// see ASUT g^ for blah blah
// this is in ASUI not ASUT also because it's a ScreenLine move, not FileLine.
class ASUI_NM_g$_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1) -> AccessibilityTextElement {
        return applyMove { asNormalMode.gDollarSign(times: count, on: $0) }
    }
    
}


// count
extension ASUI_NM_g$_Tests {

    // this test contains blanks
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = """
testing with count         
should be awesome to use       
  actually nobody uses count😂️          
LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 3)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 82)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_if_the_count_is_too_high_it_ends_up_on_the_last_line() {
        let textInAXFocusedElement = """
testing with count         
should be awesome to use       
  actually nobody uses count😂️          
LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 69)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 105)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "O")
    }
    
}


// TextFields and TextViews
extension ASUI_NM_g$_Tests {
    
    func test_that_if_the_line_ends_does_not_end_with_a_linefeed_it_goes_one_character_before_the_end() {
        let textInAXFocusedElement = "hello world and that's a long one that we gonna wrap 🗺️"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(times: 6, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 69)
        
        XCTAssertEqual(accessibilityElement.caretLocation, 53)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "🗺️")
    }
    
    func test_that_it_does_not_set_the_ATE_ColumnNumbers_to_nil() {
        let textInAXFocusedElement = """
when using g$
the ColumnNumbers don't get set to nil
as this only happens for
$
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gk(on: $0) }
        
        _ = applyMoveBeingTested()

        XCTAssertNotNil(AccessibilityTextElement.fileLineColumnNumber)
        XCTAssertNotNil(AccessibilityTextElement.screenLineColumnNumber)
    }

}
    

// TextViews
extension ASUI_NM_g$_Tests {
    
    func test_that_if_the_line_ends_with_a_linefeed_it_goes_two_characters_before_the_end() {
        let textInAXFocusedElement = """
indeed that is a multiline
and yes my friend they all
gonna be wrapped
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(to: "u", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.caretLocation, 25)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "e")
    }
    
    func test_that_if_a_line_is_empty_it_does_not_move() {
        let textInAXFocusedElement = """
g$ shouldn't go up one else

it's a bug! my friend hehehehe
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.k(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.caretLocation, 28)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
    }

}
