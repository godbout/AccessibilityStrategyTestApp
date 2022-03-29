import XCTest
@testable import AccessibilityStrategy


// gI calls 0, so most of the tests are there.
// here we test the difference between gI and 0, which is that 0 keeps the block cursor
// as it stays in NM, while gI will switch to IM so selectedLength is gonna be different.
class ASUT_NM_gI_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        return asNormalMode.gI(on: element)
    }
    
}


// line
extension ASUT_NM_gI_Tests {
   
    func test_that_this_move_sets_the_selectedLength_to_0_because_it_is_a_move_that_will_go_into_IM() {
        let text = """
 hey you know what, eve more
   let's do many lines and with ScreenLines and shit
so that we make sure everything works properly!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 129,
            caretLocation: 79,
            selectedLength: 1,
            selectedText: "i",
            fullyVisibleArea: 0..<129,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 129,
                number: 8,
                start: 73,
                end: 82
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)

        XCTAssertEqual(returnedElement.caretLocation, 29)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertEqual(returnedElement.selectedText, nil)
    }
    
}
