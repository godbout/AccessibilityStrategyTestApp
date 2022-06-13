import XCTest
@testable import AccessibilityStrategy
import Common


// 1. huh so it seems that LYS Characterwise is actually behaving like LYS Linewise LMAO 
//    the difference is not in what was the LYS, but what's the current Visual Style
// 2. LYS should be changed from Characterwise to Linewise, this is tested here 
class ASUI_VML_pWhenLastYankStyleWasCharacterwise_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(lastYankStyle: .characterwise, visualStyle: .linewise)
    
           
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asVisualMode.p(on: $0, VimEngineState(appFamily: appFamily, lastYankStyle: state.lastYankStyle, visualStyle: state.visualStyle)) }
    }
    
}

// TextFields
extension ASUI_VML_pWhenLastYankStyleWasCharacterwise_Tests {
    
    func test_that_for_TF_the_replaced_text_is_copied_and_available_in_the_Pasteboard_and_that_it_changes_the_LYS_to_Characterwise() {
        let textInAXFocusedElement = "gonna select the whole line and replace it and remove linefeed in copied text"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        
        copyToClipboard(text: "  😂️ext to be copied\n")
        
        _ = applyMoveBeingTested()
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "gonna select the whole line and replace it and remove linefeed in copied text")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
    }

}


// TextAreas
extension ASUI_VML_pWhenLastYankStyleWasCharacterwise_Tests {
    
    func test_that_for_TA_the_replaced_text_is_copied_and_available_in_the_Pasteboard_and_that_it_changes_the_LYS_to_Characterwise() {
        let textInAXFocusedElement = """
what is being selected
and replaced
is gonna get copied
in the clipboard
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }
        applyMove { asVisualMode.VFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, state) }
        
        copyToClipboard(text: "text to pasta\nhere and there")
               
        _ = applyMoveBeingTested()

        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "and replaced\nis gonna get copied\n")
        XCTAssertEqual(state.lastYankStyle, .linewise)
    }

}
