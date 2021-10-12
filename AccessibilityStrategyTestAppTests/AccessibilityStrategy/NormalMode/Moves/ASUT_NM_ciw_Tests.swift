@testable import AccessibilityStrategy
import XCTest


// ciw uses TE.innerWord. this is already fully tested.
// contrary to TE.aWord, innerWord never returns nil because Vim always finds an innerWord.
// here we just test what is special to the ciw move itself (caretLocation, selectedLength correct, selectedText).
class ASUT_NM_ciw_Tests: ASNM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.ciw(on: element) 
    }
    
}


// Both
extension ASUT_NM_ciw_Tests {

    func test_that_when_it_finds_an_inner_word_it_selects_the_range_and_will_delete_the_selection() {
        let text = "that's some cute     text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 32,
            caretLocation: 14,
            selectedLength: 1,
            selectedText: " ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 32,
                number: 1,
                start: 0,
                end: 16
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 4)
        XCTAssertEqual(returnedElement?.selectedText, "")    
    }
    
}
