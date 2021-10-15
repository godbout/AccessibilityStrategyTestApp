import XCTest
import AccessibilityStrategy


class ASUI_VML_gj_Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asVisualMode.gjForVisualStyleLinewise(on: $0)}
    }

}


// TextFields
extension ASUI_VML_gj_Tests {
    
    func test_that_in_TextFields_basically_it_does_nothing() {
        let textInAXFocusedElement = "hehe you little fucker"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 22)
    }
    
}
