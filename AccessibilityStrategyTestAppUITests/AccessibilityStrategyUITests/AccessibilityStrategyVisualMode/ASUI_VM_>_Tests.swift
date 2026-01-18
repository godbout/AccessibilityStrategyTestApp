import XCTest
@testable import AccessibilityStrategy
import Common


// see < for blah blah
class ASUI_VM_rightChevron_Tests: ASUI_VM_BaseTests {
    
    var vimEngineState = VimEngineState(visualStyle: .characterwise)

    private func applyMoveBeingTested(times count: Int = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        vimEngineState.appFamily = appFamily
        
        return applyMove { asVisualMode.rightChevron(times: count, on: $0, vimEngineState) }
    }

}


// count
extension ASUI_VM_rightChevron_Tests {

    func test_that_the_count_is_implemented() {
        let textInAXFocusedElement = """
seems that even the normal
🖕️ase fails LMAO
sooome more
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(times: 3)
            
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
            🖕️ase fails LMAO
            sooome more
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 39)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}


// TextFields and TextViews
extension ASUI_VM_rightChevron_Tests {
    
    func test_that_in_normal_setting_it_adds_4_spaces_at_the_beginning_of_the_lines_that_hold_some_or_the_whole_the_selection_and_sets_the_caret_to_the_firstNonBlank_of_the_first_line_of_the_selection() {
        let textInAXFocusedElement = """
seems that even the normal
  🖕️ase fails LMAO
some more
and more
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(times: 2, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()
            
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
      🖕️ase fails LMAO
    some more
and more
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 33)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_it_does_not_shift_EmptyLines() {
        let textInAXFocusedElement = """
a line empty means with nothing

or just a linefeed
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.gg(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
    a line empty means with nothing

    or just a linefeed
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 4)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR and Electron
extension ASUI_VM_rightChevron_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
seems that even the normal
  🖕️ase fails LMAO
some more
and more
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(times: 2, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
            
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
      🖕️ase fails LMAO
    some more
and more
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 33)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
seems that even the normal
  🖕️ase fails LMAO
some more
and more
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.G(times: 2, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
            
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
      🖕️ase fails LMAO
    some more
and more
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 33)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}
