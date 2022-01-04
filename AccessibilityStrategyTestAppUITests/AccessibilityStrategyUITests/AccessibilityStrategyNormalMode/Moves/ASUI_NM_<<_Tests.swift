import XCTest
@testable import AccessibilityStrategy

 
class ASUI_NM_leftChevronLeftChevron_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        var state = VimEngineState(pgR: pgR)
        
        return applyMove { asNormalMode.leftChevronLeftChevron(on: $0, &state) }
    }
    
}


// Both
extension ASUI_NM_leftChevronLeftChevron_Tests {
    
    func test_that_in_normal_setting_it_removes_4_spaces_at_the_beginning_of_a_line_and_sets_the_caret_to_the_first_non_blank_of_the_line() {
        let textInAXFocusedElement = """
seems that even the normal
       🖕️ase fails LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
seems that even the normal
   🖕️ase fails LMAO
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 30)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_it_removes_all_the_spaces_if_there_are_4_or_less() {
        let textInAXFocusedElement = """
 now the line
  😀️as just two
 spaces
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
 now the line
😀️as just two
 spaces
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 14)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}


// PGR
extension ASUI_NM_leftChevronLeftChevron_Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
seems that even the normal
hehe
       🖕️ase fails LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
seems that even the normal
hehe   🖕️ase fails LMAO
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 27)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, "h")
    }
    
}
