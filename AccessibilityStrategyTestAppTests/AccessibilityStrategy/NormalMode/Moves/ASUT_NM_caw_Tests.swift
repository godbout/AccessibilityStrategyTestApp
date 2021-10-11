@testable import AccessibilityStrategy
import XCTest


// see ciw for blah blah
class ASUT_NM_caw_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.caw(on: element) 
    }
    
}


// Both
extension ASUT_NM_caw_Tests {
    
    func test_that_when_it_finds_a_word_it_selects_the_range_and_will_delete_the_selection() {
        let text = "that's some cute     text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 50,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 50,
                number: 1,
                start: 0,
                end: 50
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 9)
        XCTAssertEqual(returnedElement?.selectedText, "")      
    }

    func test_that_when_it_cannot_find_a_word_the_caret_goes_to_the_end_limit_of_the_text() {
        let text = """
some text
and also a lot of spaces at the end of this line        
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 66,
            caretLocation: 60,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 66,
                number: 2,
                start: 10,
                end: 66
            )
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 65)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertEqual(returnedElement?.selectedText, nil)      
   }
    
}
