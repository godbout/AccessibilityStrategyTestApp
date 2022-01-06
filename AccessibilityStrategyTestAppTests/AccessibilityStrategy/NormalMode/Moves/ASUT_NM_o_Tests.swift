@testable import AccessibilityStrategy
import XCTest


// see NM O
class ASUT_NM_o_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.o(on: element, VimEngineState(pgR: false))
    }
    
}


// TextViews
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
        
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_a_file_line_ends_with_a_linefeed_it_creates_a_new_line_below() {
        let text = """
that's a multiline and o will create a new line
between the first file line and the second file line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 100,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "i",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 100,
                number: 1,
                start: 0,
                end: 48
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 13)
        XCTAssertEqual(returnedElement.selectedLength, 34)
        XCTAssertEqual(returnedElement.selectedText, "iline and o will create a new line\n")
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
            caretLocation: 110,
            selectedLength: 1,
            selectedText: "d",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 160,
                number: 2,
                start: 75,
                end: 160
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 110)
        XCTAssertEqual(returnedElement.selectedLength, 50)
        XCTAssertEqual(returnedElement.selectedText, "d it's still gonna work coz 🪄️🪄️🪄️ we're genius\n")
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
            selectedLength: 1,
            selectedText: "\n",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 137,
                number: 2,
                start: 60,
                end: 61
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 60)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertEqual(returnedElement.selectedText, "\n")
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
            length: 58,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "s",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 58,
                number: 2,
                start: 5,
                end: 30
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 7)
        XCTAssertEqual(returnedElement.selectedText, "s🙃️ace\n    ")
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
        
        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertEqual(returnedElement.selectedText, "\n")
    }
    
}
