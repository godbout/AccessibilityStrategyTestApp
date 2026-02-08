import XCTest
@testable import AccessibilityStrategy
import Common


// yes, only passing `innerWord` here. both `innerWord` and `innerWORD` are heavily
// tested, so as long as we pass the proper func from `diw` and `diW` then we're all good.
// `diw` and `diW` are therefore not tested independently as it was before, but basically
// it was copy pasted LMAO. and when started adding the copy deletion, didn't make sense anymore
// to separate the implementations.
// can see daw for blah blah.
class ASUI_NM_diWw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.diWw(on: $0, using: $0.fileText.innerWord, &vimEngineState) }
    }
    
}


extension ASUI_NM_diWw_Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty😂️much     📏️traight forward if you ask me
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
like honestly that one should be
   😂️much     📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 36)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_if_the_caret_ends_up_after_the_end_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = """
repositionin🇫🇷️ofwhat
the block cursor is important!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
repositionin🇫🇷️
the block cursor is important!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 5)
    }

}


// PGR and Electron
extension ASUI_NM_diWw_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty-much     📏️traight forward if you ask me
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
like honestly that one should be
   -much     📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 36)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
like honestly that one should be
   pretty-much     📏️traight forward if you ask me
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
like honestly that one should be
   -much     📏️traight forward if you ask me
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 36)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}
