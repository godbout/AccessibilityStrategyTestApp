@testable import AccessibilityStrategy
import XCTest


// see g^ for blah blah
class ASUT_NM_g$_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.gDollarSign(on: element) 
    }
    
}


// line
extension ASUT_NM_g$_Tests {
    
    func test_conspicuously_that_it_stops_at_screen_lines() {
        let text = """
this move stops at screen lines, which means it will
stop even without a linefeed. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 108,
            caretLocation: 5,
            selectedLength: 1,
            selectedText: "m",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 108,
                number: 1,
                start: 0,
                end: 33
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 32)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}
        

// Both
extension ASUT_NM_g$_Tests {
    
    func test_that_if_the_line_ends_does_not_end_with_a_linefeed_it_goes_one_character_before_the_end() {
        let text = "hello world and that's a long one that we gonna wrap 🗺️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 36,
            selectedLength: 1,
            selectedText: "a",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 2,
                start: 30,
                end: 56
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 53)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }

}
    

// TextViews
extension ASUT_NM_g$_Tests {
    
    func test_that_if_the_line_ends_with_a_linefeed_it_goes_two_characters_before_the_end() {
        let text = """
indeed that is a multiline
and yes my friend they all
gonna be wrapped
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 70,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "u",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 2,
                start: 17,
                end: 27
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 25)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_a_line_is_empty_it_does_not_move() {
        let text = """
g$ shouldn't go up one else

it's a bug! my friend hehehehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 59,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 3,
                start: 28,
                end: 29
            )!
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 28)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }

}
