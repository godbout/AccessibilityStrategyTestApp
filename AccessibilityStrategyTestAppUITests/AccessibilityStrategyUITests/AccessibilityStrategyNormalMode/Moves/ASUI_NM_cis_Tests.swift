@testable import AccessibilityStrategy
import XCTest
import Common


class ASUI_NM_cis_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily) 
        
        return applyMove { asNormalMode.cis(on: $0, &vimEngineState) }
    }
    
}


// TextFields and TextViews
extension ASUI_NM_cis_Tests {
    
    func test_that_when_it_finds_an_innerSentence_it_selects_the_range_and_will_delete_the_selection() {
        let textInAXFocusedElement = """
ok so here

we're gonna deal with sentences. and shit. lol.
are you OK??
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 3, on: $0) }
        applyMove { asNormalMode.e(times: 2, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ok so here

 and shit. lol.
are you OK??
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 12)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    // TODO: more???
    // 1. what is the shit about cip indentation. shouldn't be needed here
    // 2. maybe later we wanna do tests ON EL?
    
}


// PGR and Electron
extension ASUI_NM_cis_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
ok so here

we're gonna deal with sentences. and shit. lol.
are you OK??
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        applyMove { asNormalMode.b(times: 2, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ok so here

we're gonna deal with sentences.  lol.
are you OK??
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 45)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
ok so here

we're gonna deal with sentences. and shit. lol.
are you OK??
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        applyMove { asNormalMode.dollarSign(on: $0) }
        applyMove { asNormalMode.b(times: 2, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
ok so here

we're gonna deal with sentences.  lol.
are you OK??
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 45)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}
