import XCTest
@testable import AccessibilityStrategy
import Common


// careful. dip is special in the sense that blank lines are paragraph boundaries, which is not the case with {}
class ASUI_NM_dip_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.dip(on: $0, &state) }
    }
    
}


extension ASUI_NM_dip_Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = """
this is to check
that

the block cursor
ends up in the
right

place
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this is to check
that


place
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 23)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

}


// PGR and Electron
extension ASUI_NM_dip_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
this is to check
that

the block cursor
ends up in the
right

place
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this is to check
that


place
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 23)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
this is to check
that

the block cursor
ends up in the
right

place
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this is to check
that


place
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 23)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}
