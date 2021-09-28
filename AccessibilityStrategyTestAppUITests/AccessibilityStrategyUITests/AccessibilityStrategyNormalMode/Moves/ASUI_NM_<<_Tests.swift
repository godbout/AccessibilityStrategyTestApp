import XCTest
import AccessibilityStrategy

 
class ASUI_NM_leftChevronLeftChevron_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.leftChevronLeftChevron(on: $0) }
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
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.caretLocation, 14)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}
