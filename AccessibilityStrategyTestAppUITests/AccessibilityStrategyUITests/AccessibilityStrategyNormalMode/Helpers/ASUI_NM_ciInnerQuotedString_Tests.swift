@testable import AccessibilityStrategy
import XCTest


// see ASUT ciInnerQuotedString for blah blah
class ASUI_NM_ciInnerQuotedString_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(using quote: Character, pgR: Bool = false) -> AccessibilityTextElement? {
        var bipped = false
        
        return applyMove { asNormalMode.ciInnerQuotedString(using: quote, on: $0, pgR: pgR, &bipped) }
    }
    
}


// copy deleted text
extension ASUI_NM_ciInnerQuotedString_Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let textInAXFocusedElement = """
finally dealing with the "real stuff"!
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "l", on: $0) }
        copyToClipboard(text: "some fake shit")
        _ = applyMoveBeingTested(using: "\"")
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "real stuff")
    }
    
}


extension ASUI_NM_ciInnerQuotedString_Tests {
    
    func test_that_if_the_caret_is_between_quotes_the_content_within_the_quotes_is_deleted_and_the_caret_moves() {
        let textInAXFocusedElement = """
finally dealing with the "real stuff"!
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "l", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "\"")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
finally dealing with the ""!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
        
    func test_that_if_the_caret_is_before_the_quotes_then_the_content_within_is_deleted_and_the_caret_moves() {
        let textInAXFocusedElement = """
now the caret 💨️💨️💨️ is before the ` shit with 🥺️☹️😂️ h😀️ha👅️ ` backtick quotes hhohohoo🤣️
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "r", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "`")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
now the caret 💨️💨️💨️ is before the `` backtick quotes hhohohoo🤣️
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 39)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }

    func test_that_if_there_are_three_quotes_then_the_correct_content_is_deleted_and_the_caret_moves() {
        let textInAXFocusedElement = """
that's ' three quotes ' in there
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "o", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "'")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
that's '' in there
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 8)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
    
    func test_that_current_when_the_caret_is_at_a_quote_it_deletes_the_correct_content() {
        let textInAXFocusedElement = """
that's " four quotes " in " there "
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.F(to: "\"", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "\"")
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
that's " four quotes " in ""
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 27)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
        
}


// PGR
extension ASUI_NM_ciInnerQuotedString_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
finally dealing with the "real stuff"!
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.F(to: "l", on: $0) }
        let accessibilityElement = applyMoveBeingTested(using: "\"", pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
finally dealing with the "!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 25)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
