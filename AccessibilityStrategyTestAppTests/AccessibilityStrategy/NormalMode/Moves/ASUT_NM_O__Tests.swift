@testable import AccessibilityStrategy
import XCTest


// most of the tests are here. there's still two in UI though as
// if we insert a new line before the first line, the caret needs to be
// repositioned. hence using the ATEAdaptor. hence the UI Tests.
class ASUT_NM_O__Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.O(on: element) 
    }
    
}


// line
extension ASUT_NM_O__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 92,
            selectedLength: 1,
            selectedText: "a",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 5,
                start: 80,
                end: 101
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 61)
        XCTAssertEqual(returnedElement?.selectedText, "this move does not stop at screen lines. it will just pass by\n")
    }
     
}


// TextFields
extension ASUT_NM_O__Tests {
    
    func test_that_for_a_TextField_it_does_nothing() {
        let text = "O shouldn't do anything in a TextField!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 23,
            selectedLength: 1,
            selectedText: " ",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 39
            )
        )
        
		let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_O__Tests {
    
    func test_that_in_normal_setting_it_creates_a_new_line_above_the_current_one() {
        let text = """
tha😄️t's a mu😄️ltiline
an😄️😄️d O will
create a n😄️ew line
abo😄️ve!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 72,
            caretLocation: 33,
            selectedLength: 1,
            selectedText: "d",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 3,
                start: 25,
                end: 37
            )
        )
                
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 24)
        XCTAssertEqual(returnedElement?.selectedText, "tha😄️t's a mu😄️ltiline\n")
    }
    
    func test_that_if_on_an_empty_line_it_will_still_create_a_line_above() {
        let text = """
there is now

an empty line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 27,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "\n",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 2,
                start: 13,
                end: 14
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 12)
        XCTAssertEqual(returnedElement?.selectedText, "there is now\n")
    }

    func test_that_if_on_the_last_empty_line_it_creates_a_line_below_and_the_caret_stays_on_the_current_line() {
        let text = """
now the caret
will be on
the last empty line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 45,
            caretLocation: 45,
            selectedLength: 0,
            selectedText: "",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 45,
                number: 6,
                start: 45,
                end: 45
            )
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 25)
        XCTAssertEqual(returnedElement?.selectedLength, 19)
        XCTAssertEqual(returnedElement?.selectedText, "the last empty line\n")
    }

    func test_that_if_on_the_last_non_empty_line_it_creates_a_line_below_and_the_caret_stays_on_the_current_line() {
        let text = """
now the caret
will be on
the last empty line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 40,
            selectedLength: 1,
            selectedText: "l",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 5,
                start: 34,
                end: 44
            )
        )

        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 14)
        XCTAssertEqual(returnedElement?.selectedLength, 10)
        XCTAssertEqual(returnedElement?.selectedText, "will be on\n")
    }

    func test_that_it_creates_a_line_above_and_goes_to_the_same_indentation_as_the_current_line() {
        let text = """
now there's
    some indent
but it should work
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 46,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "m",
            currentLine: AccessibilityTextElementLine(
                fullTextValue: text,
                fullTextLength: 46,
                number: 2,
                start: 12,
                end: 21
            )
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 0)
        XCTAssertEqual(returnedElement?.selectedLength, 11)
        XCTAssertEqual(returnedElement?.selectedText, "now there's\n    ")
    }
    
}
