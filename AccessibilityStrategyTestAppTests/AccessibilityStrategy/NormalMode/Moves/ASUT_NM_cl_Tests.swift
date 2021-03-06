@testable import AccessibilityStrategy
import XCTest
import Common


class ASUT_NM_cl_Tests: ASUT_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: .auto)
        
        return applyMoveBeingTested(times: count, on: element, &state)
    }
        
    private func applyMoveBeingTested(times count: Int = 1, on element: AccessibilityTextElement, _ vimEngineState: inout VimEngineState) -> AccessibilityTextElement {
        return asNormalMode.cl(times: count, on: element, &vimEngineState)
    }
    
}


// count
extension ASUT_NM_cl_Tests {
    
    func test_that_it_implements_the_count_system() {
        let text = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 1,
            selectedLength: 1,
            selectedText: "w",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 1,
                start: 0,
                end: 19
            )!
        )
                
        let returnedElement = applyMoveBeingTested(times: 4, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 1)
        XCTAssertEqual(returnedElement.selectedLength, 4)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
    func test_that_if_the_count_is_too_high_it_stops_at_the_end_limit_of_the_line() {
        let text = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 80,
            caretLocation: 37,
            selectedLength: 1,
            selectedText: "t",
            fullyVisibleArea: 0..<80,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 80,
                number: 2,
                start: 19,
                end: 44
            )!
        )
        
        let returnedElement = applyMoveBeingTested(times: 69, on: element)

        XCTAssertEqual(returnedElement.caretLocation, 37)
        XCTAssertEqual(returnedElement.selectedLength, 6)
        XCTAssertEqual(returnedElement.selectedText, "")
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


// Both
extension ASUT_NM_cl_Tests {
    
    func test_that_in_normal_setting_it_deletes_the_character_at_caret_location() {
        let text = " cl to delete a character on the right"
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 37,
            caretLocation: 18,
            selectedLength: 1,
            selectedText: "r",
            fullyVisibleArea: 0..<37,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 37,
                number: 1,
                start: 0,
                end: 37
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 18)
        XCTAssertEqual(returnedElement.selectedLength, 1)
        XCTAssertEqual(returnedElement.selectedText, "")
    }
    
}


// TextViews
extension ASUT_NM_cl_Tests {
    
    func test_that_on_an_empty_line_it_does_not_delete_the_linefeed_and_deselects_the_linefeed() {
        let text = """
  blah blah some line

haha geh
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 31,
            caretLocation: 22,
            selectedLength: 1,
            selectedText: "\n",
            fullyVisibleArea: 0..<31,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 31,
                number: 2,
                start: 22,
                end: 23
            )!
        )
        
        let returnedElement = applyMoveBeingTested(on: element)
        
        XCTAssertEqual(returnedElement.caretLocation, 22)
        XCTAssertEqual(returnedElement.selectedLength, 0)
        XCTAssertNil(returnedElement.selectedText)
    }
    
}
