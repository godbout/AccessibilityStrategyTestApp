@testable import AccessibilityStrategy
import XCTest


// ciw uses TE.innerWord. this is already fully tested.
// contrary to TE.aWord, innerWord never returns nil because Vim always finds an innerWord.
// PGR in UIT.
class ASUT_NM_ciw_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asNormalMode.ciw(on: element, pgR: false) 
    } 
}


// copy deleted text
extension ASUT_NM_ciw_Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let text = "that's some cute-boobies      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textArea,
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
                end: 49
            )!
        )
       
        copyToClipboard(text: "some fake shit")
        _ = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "cute")
    }
    
}


// both
extension ASUT_NM_ciw_Tests {
    
    func test_that_when_it_finds_an_inner_word_it_selects_the_range_and_will_delete_the_selection() {
        let text = "that's some cute-boobies      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textArea,
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
                end: 49
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 12)
        XCTAssertEqual(returnedElement?.selectedLength, 4)
        XCTAssertEqual(returnedElement?.selectedText, "")
    }
    
}
