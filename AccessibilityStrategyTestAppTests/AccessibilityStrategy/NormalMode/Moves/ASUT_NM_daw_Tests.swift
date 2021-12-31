@testable import AccessibilityStrategy
import XCTest


// see caw
class ASUT_NM_daw_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement?, pgR: Bool = false, _ bipped: inout Bool) -> AccessibilityTextElement? {
        return asNormalMode.daw(on: element, pgR: pgR, &bipped)
    }
    
}


extension ASUT_NM_daw_Tests {
    
    func test_that_it_does_not_Bip_when_it_can_find_aWord() {
        let text = "that's some cute      text in here don't you think?"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 51,
            caretLocation: 13,
            selectedLength: 1,
            selectedText: "u",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 51,
                number: 1,
                start: 0,
                end: 51
            )!
        )
        
        var bipped = false
        let _ = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertFalse(bipped)
    }
        
    func test_that_it_Bips_when_it_cannot_find_aWord() {
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
            )!
        )
        
        var bipped = false
        let _ = applyMoveBeingTested(on: element, &bipped)
        
        XCTAssertTrue(bipped)
    }
       
}
