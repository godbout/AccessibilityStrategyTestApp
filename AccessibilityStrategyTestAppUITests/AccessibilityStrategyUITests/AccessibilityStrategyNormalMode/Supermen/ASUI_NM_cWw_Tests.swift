@testable import AccessibilityStrategy
import XCTest
import Common


// the Vim doc says that if the caret is on a blank, `cw` acts like `ce`: http://vimdoc.sourceforge.net/htmldoc/motion.html#word
// as usual with Vim, this is not true. e.g.: full-time. with the caret on `-`, `ce` makes `full` while `cw` makes `fulltime`
// for rest of blah blah blah see ciWw.
class ASUI_NM_cWw_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cWw(on: $0, using: $0.fileText.innerWORD, &state) }
    }
    
}


// PGR and Electron
extension ASUI_NM_cWw_Tests {
    
    func test_that_if_the_caret_is_on_a_non_blank_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "😂️😂️😂️😂️hehehe gonna use cw on this sentence"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "😂️ gonna use cw on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_if_the_caret_is_on_a_blank_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = "😂️😂️😂️😂️hehehe                   gonna use cw on this sentence"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.E(on: $0) }
        applyMove { asNormalMode.l(times: 4, on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "😂️😂️😂️😂️hehehe   gonna use cw on this sentence")
        XCTAssertEqual(accessibilityElement.caretLocation, 21)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
        
}
