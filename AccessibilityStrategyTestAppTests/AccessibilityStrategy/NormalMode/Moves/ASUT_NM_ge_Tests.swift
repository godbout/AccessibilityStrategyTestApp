@testable import AccessibilityStrategy
import XCTest


// see b for blah blah
class ASUT_NM_ge_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.ge(times: count, on: element) 
    }
    
}


// count
extension ASUT_NM_ge_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "we gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 30,
            selectedLength: 1,
            selectedText: "u",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 3, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 15)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_stops_at_the_beginning_of_the_text_if_the_count_is_too_high() {
        let text = "😀️e gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 44,
            caretLocation: 32,
            selectedLength: 1,
            selectedText: "u",
            fullyVisibleArea: 0..<44,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 44,
                number: 1,
                start: 0,
                end: 44
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
}


// both
extension ASUT_NM_ge_Tests {
    
    func test_that_when_there_is_no_word_backward_it_goes_to_0() {
        let text = "🚔️aretLocation at the first character of the text"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 0,
            selectedLength: 3,
            selectedText: "🚔️",
            fullyVisibleArea: 0..<50,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 0)
        XCTAssertEqual(returnedElement.selectedLength, 3)
        XCTAssertNil(returnedElement.selectedText)
    }
       
    func test_that_when_there_is_a_word_backward_it_goes_to_the_end_of_it() {
        let text = """
now we're talking
you little mf
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 24,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 2,
                start: 18,
                end: 31
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 20)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
