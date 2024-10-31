import XCTest
@testable import AccessibilityStrategy
import Common


// same for VMC and VML
class ASUI_VM_leftChevron_Tests: ASUI_VM_BaseTests {
    
    var state = VimEngineState(visualStyle: .characterwise)

    private func applyMoveBeingTested(times count: Int = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        state.appFamily = appFamily
        
        return applyMove { asVisualMode.leftChevron(times: count, on: $0, state) }
    }

}


// count
extension ASUI_VM_leftChevron_Tests {
    
    func test_that_the_count_is_implemented() {
        let textInAXFocusedElement = """
    seems that even the normal
                  🖕️ase fails LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) } 
        applyMove { asVisualMode.G(on: $0, state) } 
        let accessibilityElement = applyMoveBeingTested(times: 3)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
      🖕️ase fails LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// Both
extension ASUI_VM_leftChevron_Tests {
    
    func test_that_in_normal_setting_it_removes_4_spaces_at_the_beginning_of_each_line_of_the_selection_and_sets_the_caret_to_the_first_non_blank_of_the_first_line() {
        let textInAXFocusedElement = """
seems that even the normal
       🖕️ase fails LMAO
       🖕️ase fails LMAO
      heheh
some more
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.k(on: $0) } 
        applyMove { asVisualMode.vFromNormalMode(on: $0) } 
        applyMove { asVisualMode.k(times: 2, on: $0, state) } 
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
   🖕️ase fails LMAO
   🖕️ase fails LMAO
  heheh
some more
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 30)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_it_removes_all_the_spaces_if_there_are_4_or_less() {
        let textInAXFocusedElement = """
 now the line
  😀️as just two
 spaces
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.G(on: $0, state) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
now the line
😀️as just two
spaces
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// PGR and Electron
extension ASUI_VM_leftChevron_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
seems that even the normal
hehe
       🖕️ase fails LMAO
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
hehe
   🖕️ase fails LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 27)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_and_deletes_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
seems that even the normal
hehe
       🖕️ase fails LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asNormalMode.k(on: $0) }
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
seems that even the normal
hehe
   🖕️ase fails LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 27)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}
