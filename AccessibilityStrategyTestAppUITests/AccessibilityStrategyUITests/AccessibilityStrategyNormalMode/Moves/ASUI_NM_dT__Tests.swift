import XCTest
@testable import AccessibilityStrategy


// see dF for blah blah
class ASUI_NM_dT__Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(with character: Character) -> AccessibilityTextElement? {
        return applyMove(with: character) { character, focusedElement in
            asNormalMode.dT(to: character, on: focusedElement)
        }
    }
    
}


extension ASUI_NM_dT__Tests {
    
    func test_that_the_block_cursor_is_repositioned_correctly_after_the_deletion() {
        let textInAXFocusedElement = """
dT on a multiline
should wor⛱️
on a line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        let accessibilityElement = applyMoveBeingTested(with: "w")
        
        XCTAssertEqual(accessibilityElement?.text.value, """
dT on a multiline
should w⛱️
on a line
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 2)
    }
    
}
