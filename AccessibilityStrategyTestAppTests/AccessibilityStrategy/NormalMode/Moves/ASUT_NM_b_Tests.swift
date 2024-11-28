@testable import AccessibilityStrategy
import XCTest


// now TE funcs can return nil if a word is not found (backward, forward, etc.).
// the TE funcs are heavily tested by themselves. here we test only what is necessary for
// this move, which is the difference between when a TE func returns nil (can't find word) and returns a range (finds word).
class ASUT_NM_b_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.b(times: count, on: element) 
    }
    
}


// count
extension ASUT_NM_b_Tests {
    
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

        XCTAssertEqual(returnedElement.caretLocation, 17)
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


// Both
extension ASUT_NM_b_Tests {
    
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
       
    func test_that_when_there_is_a_word_backward_it_goes_to_the_beginning_of_it() {
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
        
        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
