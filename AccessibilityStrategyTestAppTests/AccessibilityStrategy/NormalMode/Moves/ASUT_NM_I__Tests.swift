@testable import AccessibilityStrategy
import XCTest


class ASUT_NM_I__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.I(on: element) 
    }
    
}


// line
extension ASUT_NM_I__Tests {
    
    func test_conspicuously_that_it_does_not_stop_at_screen_lines() {
        let text = """
  this move stops at screen lines, which         🇧🇶️eans it will
  stop even without a linefeed. that's         how special it is.
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 132,
            caretLocation: 54,
            selectedLength: 1,
            selectedText: "e",
            fullyVisibleArea: 0..<132,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 132,
                number: 2,
                start: 35,
                end: 67
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 2)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
     
}


// Both
extension ASUT_NM_I__Tests {
    
    func test_that_in_normal_setting_it_goes_at_the_beginning_of_the_line() {
        let text = "so here 💘️💘️💘️ are some shit of course and I will go at the beginning of the line"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 84,
            caretLocation: 68,
            selectedLength: 1,
            selectedText: "n",
            fullyVisibleArea: 0..<84,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 84,
                number: 3,
                start: 53,
                end: 76
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_goes_to_the_first_non_blank_of_the_line() {
        let text = """
so that's a line, that's for sure
     and that's the second one where we gonna put the caret
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 94,
            caretLocation: 74,
            selectedLength: 1,
            selectedText: "g",
            fullyVisibleArea: 0..<94,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 94,
                number: 4,
                start: 54,
                end: 80
            )!
        )
                
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 39)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_line_is_full_of_spaces_and_ends_with_a_linefeed_it_goes_just_before_the_linefeed() {
        let text = """
so yeah like basically we should go right before the linefeed
                     
of this previous line
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 105,
            caretLocation: 69,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<105,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 105,
                number: 4,
                start: 62,
                end: 84
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 83)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_if_the_line_is_full_of_spaces_and_does_not_end_with_a_linefeed_it_goes_to_the_end_of_the_line() {
        let text = """
so now we will have a line that is full of spaces but no linefeed
               
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 81,
            caretLocation: 72,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<81,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 81,
                number: 4,
                start: 66,
                end: 81
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 81)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
