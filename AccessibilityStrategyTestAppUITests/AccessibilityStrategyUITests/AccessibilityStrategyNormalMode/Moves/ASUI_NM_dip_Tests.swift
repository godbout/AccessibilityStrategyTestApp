import XCTest
@testable import AccessibilityStrategy
import VimEngineState


// careful. dip is special in the sense that blank lines are paragraph boundaries, which is not the case with {}
class ASUI_NM_dip_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(_ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return applyMove { asNormalMode.dip(on: $0, &vimEngineState) }
    }
    
    private func applyMoveBeingTested(appFamily: VimEngineAppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMoveBeingTested(&state)
    }
    
}


// Bip, copy deletion and LYS
extension ASUI_NM_dip_Tests {
    
    func test_that_it_always_does_not_Bip_and_sets_the_LastYankStyle_to_Linewise_and_copies_the_deletion_including_the_last_Linefeed_of_the_paragraph() {
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
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(times: 2, on: $0) }
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .characterwise)
        _ = applyMoveBeingTested(&state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
the block cursor
ends up in the
right\n
"""
        )
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
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


// PGR
extension ASUI_NM_dip_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
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
        XCTAssertEqual(accessibilityElement.caretLocation, 22)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}
