@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_ccgCaret_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(on: element, &vimEngineState)
    }
    
    private func applyMoveBeingTested(on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        // see cgg$ for blah blah
        return asNormalMode.ccgCaret(using: element.currentFileLine, on: element, &vimEngineState) 
    }
    
}


// TODO: FR


// Bip, copy deletion and LYS
extension ASUT_NM_ccgCaret_Tests {
       
}


// TextFields and TextViews
extension ASUT_NM_ccgCaret_Tests {

}
