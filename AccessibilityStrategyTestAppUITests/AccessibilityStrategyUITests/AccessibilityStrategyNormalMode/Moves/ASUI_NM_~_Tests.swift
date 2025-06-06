import XCTest
@testable import AccessibilityStrategy
import Common


// `~` and `r` are two very special cases. so the UIT and PGR may look different
// from others. this is because they delete content and paste new one, all in one move.
// implementation is also rock n roll and has a comment about it else crying ensues.
class ASUI_NM_tilde_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        return applyMove { asNormalMode.tilde(times: count, on: $0, VimEngineState(appFamily: appFamily)) }
    }
    
}


// count
extension ASUI_NM_tilde_Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = "we goNNa moVe in tHere with count 🈹️ awww"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.l(on: $0) }
        applyMove { asNormalMode.F(to: "g", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 10)
        
        XCTAssertEqual(accessibilityElement.fileText.value, "we GOnnA MOvE in tHere with count 🈹️ awww")
        XCTAssertEqual(accessibilityElement.caretLocation, 13)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, " ")
    }
    
    func test_that_when_the_count_is_too_high_it_changes_the_characters_case_until_the_end_of_the_FileLine() {
        let textInAXFocusedElement = """
we goNNa moVe in tHere with count 🈹️ awww
and one more line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 69)

        XCTAssertEqual(accessibilityElement.fileText.value, """
we GOnnA MOvE IN ThERE WITH COUNT 🈹️ AWWW
and one more line
"""
)
        XCTAssertEqual(accessibilityElement.caretLocation, 41)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "W")
    }
    
}


// Both
extension ASUI_NM_tilde_Tests {

    func test_that_in_normal_setting_it_replaces_a_lowercase_character_by_an_uppercase_one() {
        let textInAXFocusedElement = "gonna replace one of those😂️letters..."
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.B(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
      
        XCTAssertEqual(accessibilityElement.fileText.value, "gonna replace one of thosE😂️letters...")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_in_normal_setting_it_replaces_an_uppercase_character_by_a_lowercase_one() {
        let textInAXFocusedElement = "gonna replace one of thosE😂️letters..."
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.B(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
      
        XCTAssertEqual(accessibilityElement.fileText.value, "gonna replace one of those😂️letters...")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}


// PGR and Electron
extension ASUI_NM_tilde_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "gonna replace one of thOse😂️letters..."
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.B(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 5, appFamily: .pgR)
      
        XCTAssertEqual(accessibilityElement.fileText.value, "gonna replace one of THoSE😂️letters...")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "gonna replace one of thOse😂️letters..."
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.B(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 5, appFamily: .pgR)
      
        XCTAssertEqual(accessibilityElement.fileText.value, "gonna replace one of THoSE😂️letters...")
        XCTAssertEqual(accessibilityElement.caretLocation, 26)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }

}
