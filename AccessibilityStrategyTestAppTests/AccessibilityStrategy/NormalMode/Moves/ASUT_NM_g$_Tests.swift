@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_g$_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.gDollarSign(on: element) 
    }
    
}



// Both
extension ASUT_NM_g$_Tests {
    
    func test_that_if_line_ends_with_visible_character_it_goes_one_character_before_the_end() {
        let text = "hello world 🗺️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 15,
            caretLocation: 3,
            selectedLength: 1,
            selectedText: "l",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 15,
                number: 1,
                start: 0,
                end: 15
            )
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_it_sets_the_ATE_globalColumnNumber_to_nil() {
        let text = """
when using g$
the globalColumnNumber
is set to nil so that next
j or k will go to the line endLimit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 99,
            caretLocation: 51,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 99,
                number: 3,
                start: 37,
                end: 64
            )
        )
        
        AccessibilityTextElement.globalColumnNumber = 17
        
        _ = applyMoveBeingTested(on: element)

        XCTAssertNil(AccessibilityTextElement.globalColumnNumber)
    }

}
    

// TextViews
extension ASUT_NM_g$_Tests {
    
    func test_that_if_line_ends_with_linefeed_it_goes_two_characters_before_the_end() {
        let text = """
indeed
that is
multiline
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 24,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "s",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 24,
                number: 2,
                start: 7,
                end: 15
            )
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 13)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_a_line_is_empty_it_does_not_go_up_to_the_end_of_the_previous_line() {
        let text = """
g$ shouldn't
go up one else

it's a bug!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 40,
            caretLocation: 28,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 40,
                number: 3,
                start: 28,
                end: 29
            )
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 28)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }

}
