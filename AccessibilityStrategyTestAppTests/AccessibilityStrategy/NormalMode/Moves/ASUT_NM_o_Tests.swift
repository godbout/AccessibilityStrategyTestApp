@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_o_Tests: ASNM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.o(on: element) 
    }
    
}


// line
extension ASUT_NM_o_Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
this move does not stop at screen lines. it will just pass by
them like nothing happened. that's how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 115,
            caretLocation: 38,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 115,
                number: 2,
                start: 27,
                end: 59
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 38)
        XCTAssertEqual(returnedElement?.selectedLength, 23)
        XCTAssertEqual(returnedElement?.selectedText, "s. it will just pass by\n")
    }
     
}


// TextFields
extension ASUT_NM_o_Tests {
    
    func test_that_for_a_TextField_it_does_nothing() {
        let text = "o shouldn't do anything in a TextField!"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 20,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 2,
                start: 15,
                end: 29
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASUT_NM_o_Tests {
    
    func test_that_if_a_file_line_ends_with_a_linefeed_it_creates_a_new_line_below() {
        let text = """
that's a multiline and o will create a new line
between the first file line and the second file line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 101,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 101,
                number: 2,
                start: 9,
                end: 25
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.selectedLength, 34)
        XCTAssertEqual(returnedElement?.selectedText, "iline and o will create a new line\n")   
    }
    
    func test_that_if_a_file_line_does_not_end_with_a_linefeed_it_still_creates_a_new_line_below() {
        let text = """
now that's gonna be a multiline but we will put the caret at the last line
that doesn't end with a linefeed and it's still gonna work coz 🪄️🪄️🪄️ we're genius
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 160,
            caretLocation: 109,
            selectedLength: 1,
            selectedText: "n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 160,
                number: 3,
                start: 75,
                end: 112
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 109)
        XCTAssertEqual(returnedElement?.selectedLength, 51)
        XCTAssertEqual(returnedElement?.selectedText, "nd it's still gonna work coz 🪄️🪄️🪄️ we're genius\n")
    }
    
    func test_that_if_a_file_line_is_empty_it_still_creates_a_new_line_below() {
        let text = """
yeah so it always seems easy but actually it's fucking hard

and i'm doing this not because i'm a genius but because i'm pretty dumb LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 137,
            caretLocation: 60,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 137,
                number: 6,
                start: 60,
                end: 61
            )!
        )
            
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement?.caretLocation, 60)
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertEqual(returnedElement?.selectedText, "\n")
    }
    
    func test_that_the_caret_goes_to_the_same_spaces_indentation_as_the_previous_line_on_the_newly_created_line() {
        let text = """
like
    there's some s🙃️ace
so the new line follows that
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 56,
            caretLocation: 23,
            selectedLength: 3,
            selectedText: "p",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 56,
                number: 3,
                start: 17,
                end: 28
            )!
        )
                
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 23)
        XCTAssertEqual(returnedElement?.selectedLength, 6)
        XCTAssertEqual(returnedElement?.selectedText, "🙃️ace\n    ")            
    }
    
    
    func test_that_if_on_the_last_empty_line_it_does_create_a_new_line() {
        let text = """
caret on empty last line

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 25,
            caretLocation: 25,
            selectedLength: 0,
            selectedText: "",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 25,
                number: 2,
                start: 25,
                end: 25
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.selectedLength, 0)
        XCTAssertEqual(returnedElement?.selectedText, "\n")   
    }
    
}
