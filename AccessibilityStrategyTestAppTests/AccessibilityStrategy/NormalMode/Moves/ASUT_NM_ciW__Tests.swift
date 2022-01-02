@testable import AccessibilityStrategy
import XCTest


// see ciw
class ASUT_NM_ciW__Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.ciW(on: element, pgR: false) 
    } 
    
}


// both
extension ASUT_NM_ciW__Tests {
    
    func test_that_when_it_finds_an_inner_WORD_it_selects_the_range_and_will_delete_the_selection() {
        let text = "that's some cute-boobies      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 59,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: "t",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 59,
                number: 1,
                start: 0,
                end: 59
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 12)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
