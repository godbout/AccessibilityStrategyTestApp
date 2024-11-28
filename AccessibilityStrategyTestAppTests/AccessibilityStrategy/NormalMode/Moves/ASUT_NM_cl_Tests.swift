@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_cl_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cl(times: count, on: element, &vimEngineState)
    }
    
}


// Bip, copy deletion and LYS, AND count
extension ASUT_NM_cl_Tests {
    
    func test_that_when_it_is_on_an_empty_line_it_does_not_Bip_and_does_not_change_the_LastYankStyle_to_Characterwise_and_does_not_copy_anything() {
        let text = ""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 0,
            caretLocation: 0,
            selectedLength: 0,
            selectedText: "",
            fullyVisibleArea: 0..<0,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 0,
                number: 1,
                start: 0,
                end: 0
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
        XCTAssertEqual(state.lastYankStyle, .linewise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_and_the_newHeadLocation_is_before_the_end_of_the_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_including_the_character_at_newHeadLocation() {
        let text = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "g",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 3,
                start: 30,
                end: 41
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 3, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "geh")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }
    
    func test_that_when_it_is_not_on_an_empty_line_and_the_newHeadLocation_is_after_the_end_of_the_line_it_does_not_Bip_either_and_sets_the_LastYankStyle_to_Characterwise_and_copies_the_deletion_without_the_linefeed() {
        let text = """
blah blah some line
some more
  haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 49,
            selectedLength: 1,
            selectedText: "d",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 4,
                start: 41,
                end: 59
            )!
        )
        
        copyToClipboard(text: "some fake shit")
        var state = VimEngineState(lastMoveBipped: true, lastYankStyle: .linewise)
        _ = applyMoveBeingTested(times: 69, on: element, &state)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "deal with")
        XCTAssertEqual(state.lastYankStyle, .characterwise)
        XCTAssertFalse(state.lastMoveBipped)
    }

}
