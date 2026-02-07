import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_dis_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.dis(on: $0, &vimEngineState) }
    }
    
}


extension ASUI_NM_dis_Tests {
    
    func test_that_the_block_cursor_ends_up_at_the_right_place() {
        let textInAXFocusedElement = """
ok so here

we're gonna deal with sentences. and shit. lol.
are you OK??
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ok so here

we're gonna deal with sentences. and shit. 
are you OK??
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 54)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }

}


// PGR and Electron
extension ASUI_NM_dis_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
ok so here

we're gonna deal with sentences. and shit. lol.
are you OK??
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ok so here

 and shit. lol.
are you OK??
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
ok so here

we're gonna deal with sentences. and shit. lol.
are you OK??
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ok so here

 and shit. lol.
are you OK??
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}
