@testable import AccessibilityStrategy
import XCTest


// see b for blah blah
class ASUT_NM_e_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.e(times: count, on: element) 
    }
    
}


// count
extension ASUT_NM_e_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = "we gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 11,
            selectedLength: 1,
            selectedText: "v",
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

        XCTAssertEqual(returnedElement.caretLocation, 21)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
    func test_that_it_stops_at_the_end_limit_if_the_count_goes_above_it() {
        let text = "we gonna move in there with count 🈹️ awww"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 42,
            caretLocation: 28,
            selectedLength: 1,
            selectedText: "c",
            fullyVisibleArea: 0..<42,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 42,
                number: 1,
                start: 0,
                end: 42
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 41)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
}


// both
extension ASUT_NM_e_Tests {
    
    func test_that_when_there_is_no_word_forward_it_goes_to_the_end_limit() {
        let text = "in that sentence the move can't find a word forward...        "
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 62,
            caretLocation: 54,
            selectedLength: 1,
            selectedText: " ",
            fullyVisibleArea: 0..<62,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 62,
                number: 1,
                start: 0,
                end: 62
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 61)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
       
    func test_that_when_there_is_a_word_forward_it_goes_to_the_end_of_it() {
        let text = """
now we're talking
you little mf hehe
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 36,
            caretLocation: 27,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<36,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 36,
                number: 2,
                start: 18,
                end: 36
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 30)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
