import XCTest
@testable import AccessibilityStrategy


// same mindset as ci( and co.
// this is calling ciInnerQuoteString. all the tests are there.
// here we just test that we pass the pgR parameter correctly to cInnerQuoteString.
class ASUI_NM_ciSingleQuote_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested(pgR: Bool) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.ciInnerQuotedString(using: "'", on: $0, pgR: pgR) }
    }

}


// PGR
extension ASUI_NM_ciSingleQuote_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
finally dealing with the 'real stuff'!
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "l", on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
finally dealing with the '!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
