@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_ct_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, to character: Character, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.ct(times: count, to: character, on: $0, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_ct_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
ct on a multiline
should work
on a line
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "w", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ct on a multiline
swork
on a line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
ct on a multiline
should work
on a line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gk(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(to: "w", appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ct on a multiline
swork
on a line
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 19)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
