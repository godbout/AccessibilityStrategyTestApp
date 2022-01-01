@testable import AccessibilityStrategy
import XCTest


// see ASUT ciInnerQuotedString for blah blah
class ASUI_NM_ciInnerQuotedString_Tests: ASUI_NM_BaseTests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
finally dealing with the "real stuff"!
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "l", on: $0) }
        var bipped = false
        let accessibilityElement = applyMove { asNormalMode.ciInnerQuotedString(using: "\"", on: $0, pgR: true, &bipped) }
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
finally dealing with the "!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
