@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_cABlock_Tests: ASUI_NM_BaseTests {
       
    private func applyMoveBeingTested(using openingBlock: OpeningBlockType, appFamily: AppFamily) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cABlock(using: openingBlock, on: $0, &vimEngineState) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cABlock_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "n", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(using: .leftBrace, appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this case is when  is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 18)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
this case is when { is not followed
by a linefeed and
     } is preceded by a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 2, to: "n", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(using: .leftBrace, appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
this case is when  is preceded by a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 18)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
