import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_rightChevronRightChevron_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asNormalMode.rightChevronRightChevron(times: count, on: $0, VimEngineState(appFamily: appFamily)) }
    }
    
}


// count
extension ASUI_NM_rightChevronRightChevron_Tests {

    func test_that_the_count_is_implemented() {
        let textInAXFocusedElement = """
seems that even the normal
🖕️ase fails LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested(times: 3)
            
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
            🖕️ase fails LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 39)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "🖕️")
    }
    
}


// Both
extension ASUI_NM_rightChevronRightChevron_Tests {
    
    func test_that_in_normal_setting_it_adds_4_spaces_at_the_beginning_of_a_line_and_sets_the_caret_to_the_first_non_blank_of_the_line() {
        let textInAXFocusedElement = """
seems that even the normal
🖕️ase fails LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested()
            
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
    🖕️ase fails LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 31)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "🖕️")
    }
    
    func test_that_it_does_not_shift_the_line_if_the_line_is_considered_empty() {
        let textInAXFocusedElement = """
a line empty means with nothing

or just a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
a line empty means with nothing

or just a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 32)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
    }
    
}


// PGR and Electron
extension ASUI_NM_rightChevronRightChevron_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
seems that even the normal
🖕️ase fails LMAO
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
            
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
    🖕️ase fails LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 31)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
        XCTAssertEqual(accessibilityElement.selectedText, "🖕️")
    }
    
}
