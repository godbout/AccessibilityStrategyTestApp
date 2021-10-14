import XCTest
import AccessibilityStrategy


// there's no such thing as TextField for j and k as the KS takes over
// this is tested in Unit Tests.
class ASUI_NM_j_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.j(on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_j_Tests {
    
    func test_that_the_column_number_is_saved_and_reapplied_in_properly() {
        let textInAXFocusedElement = """
a line that is long
a shorter line
another long line longer than the first
another long line longer than all the other ones!!!
"""        
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(to: "g", on: $0) }
       
        let firstJ = applyMoveBeingTested()
        XCTAssertEqual(firstJ?.caretLocation, 33)
        XCTAssertEqual(firstJ?.selectedLength, 1)

        let secondJ = applyMoveBeingTested()
        XCTAssertEqual(secondJ?.caretLocation, 53)
        XCTAssertEqual(secondJ?.selectedLength, 1)

        let thirdJ = applyMoveBeingTested()
        XCTAssertEqual(thirdJ?.caretLocation, 93)
        XCTAssertEqual(thirdJ?.selectedLength, 1)
    }
    
}
