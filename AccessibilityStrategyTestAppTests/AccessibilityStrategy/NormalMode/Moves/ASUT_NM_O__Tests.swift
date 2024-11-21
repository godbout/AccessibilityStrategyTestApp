@testable import AccessibilityStrategy
import XCTest
import Common


// only PGR and tests when on the first line needs to be done in UIT. on the first line
// because in that special case we need to relocate the caret after the move.
// all the other moves are tested here.
class ASUT_NM_O__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.O(on: element, VimEngineState(appFamily: .auto))
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
            fullyVisibleArea: 0..<39,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 39
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertNil(returnedElement.selectedText)
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
            fullyVisibleArea: 0..<72,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 72,
                number: 2,
                start: 25,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 24)
        XCTAssertEqual(returnedElement.selectedText, "tha😄️t's a mu😄️ltiline\n")
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
            fullyVisibleArea: 0..<27,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 27,
                number: 2,
                start: 13,
                end: 14
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 12)
        XCTAssertEqual(returnedElement.selectedText, "there is now\n")
    }
    
    func test_that_if_on_the_last_empty_line_it_creates_a_line_above_and_the_caret_goes_on_that_line() {
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
            fullyVisibleArea: 0..<45,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 45,
                number: 4,
                start: 45,
                end: 45
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 25)
        XCTAssertEqual(returnedElement.selectedLength, 19)
        XCTAssertEqual(returnedElement.selectedText, "the last empty line\n")
    }
    
    func test_that_if_on_the_last_non_empty_line_it_creates_a_line_above_and_the_caret_goes_on_that_line() {
        let text = """
now the caret
will be on
the last empty line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 44,
            caretLocation: 43,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 3,
                start: 25,
                end: 44
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 14)
        XCTAssertEqual(returnedElement.selectedLength, 10)
        XCTAssertEqual(returnedElement.selectedText, "will be on\n")
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
            caretLocation: 26,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<46,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 46,
                number: 2,
                start: 12,
                end: 28
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 11)
        XCTAssertEqual(returnedElement.selectedText, "now there's\n    ")
    }
    
}
