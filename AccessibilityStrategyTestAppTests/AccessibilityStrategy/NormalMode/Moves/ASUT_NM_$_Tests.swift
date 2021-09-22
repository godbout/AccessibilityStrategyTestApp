@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_$_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.dollarSign(on: element) 
    }
    
}



// Both
extension ASUT_NM_$_Tests {
    
    func test_that_if_line_ends_with_visible_character_$_goes_one_character_before_the_end() {
        let text = "hello world 🗺️"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 15,
            caretLocation: 3,
            selectedLength: 1,
            selectedText: "l",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
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
when using $
the globalColumnNumber
is set to nil so that next
j or k will go to the line endLimit
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 98,
            caretLocation: 52,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullText: text,
                number: 3,
                start: 36,
                end: 63
            )
        )
        
        AccessibilityTextElement.globalColumnNumber = 17
        
        _ = applyMoveBeingTested(on: element)

        XCTAssertNil(AccessibilityTextElement.globalColumnNumber)
    }

}
    

// TextViews
extension ASUT_NM_$_Tests {
    
    func test_that_if_line_ends_with_linefeed_$_goes_two_characters_before_the_end() {
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
                fullText: text,
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
    
    func test_that_if_a_line_is_empty_$_does_not_go_up_to_the_end_of_the_previous_line() {
        let text = """
$ shouldn't
go up one else

it's a bug!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 39,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "\n",
            currentLine: AccessibilityTextElementLine(
            fullText: text,
            number: 3,
            start: 27,
            end: 28
            )
            )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 27)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }

}
