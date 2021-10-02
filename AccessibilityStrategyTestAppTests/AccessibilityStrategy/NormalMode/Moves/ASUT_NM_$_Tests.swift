import XCTest
@testable import AccessibilityStrategy


// $ uses FileLine endLimit. tested in FileLine.
// here so more to be extra sure. cheap UT aww.
class ASUT_NM_$_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.dollarSign(on: element) 
    }
    
}


// line
extension ASUT_NM_$_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: "r",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 27,
                end: 54
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 60)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
     
}
        

// Both
extension ASUT_NM_$_Tests {
    
    func test_that_if_the_line_does_not_end_with_linefeed_it_goes_one_character_before_the_end() {
        let text = "hello world and that's a long one that we gonna wrap 🗺️"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 36,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 2,
                start: 30,
                end: 56
            )
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 53)
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
            caretLocation: 49,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 98,
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
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 70,
                number: 2,
                start: 17,
                end: 27
            )
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 25)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_if_a_line_is_empty_it_does_not_move() {
        let text = """
$ shouldn't go up one else

it's a bug! my friend hehehehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 58,
            caretLocation: 27,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 2,
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
