import XCTest
import AccessibilityStrategy


// check j for all the blah blah
class ASUI_NM_k_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement {
        return applyMove { asNormalMode.k(on: $0) }
    }
    
}


// TextViews
extension ASUI_NM_k_Tests {

    func test_that_the_column_number_is_saved_and_reapplied_properly() {
        let textInAXFocusedElement = """
first one is prettyyyyy long too
a pretty long line i would believe
a shorter line
another quite long line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.h(on: $0) }
                
        let firstK = applyMoveBeingTested()
        XCTAssertEqual(firstK.caretLocation, 81)
        XCTAssertEqual(firstK.selectedLength, 1)

        let secondK = applyMoveBeingTested()
        XCTAssertEqual(secondK.caretLocation, 51)
        XCTAssertEqual(secondK.selectedLength, 1)

        let thirdK = applyMoveBeingTested()
        XCTAssertEqual(thirdK.caretLocation, 18)
        XCTAssertEqual(thirdK.selectedLength, 1)
    }
    
}

