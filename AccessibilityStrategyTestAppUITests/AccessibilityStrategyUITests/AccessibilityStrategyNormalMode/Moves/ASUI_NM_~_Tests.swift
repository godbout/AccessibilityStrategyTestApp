import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_tilde_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.tilde(times: count, on: $0, pgR: pgR) }
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
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "we GOnnA MOvE in tHere with count 🈹️ awww")
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, " ")
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

        XCTAssertEqual(accessibilityElement?.fileText.value, """
we GOnnA MOvE IN ThERE WITH COUNT 🈹️ AWWW
and one more line
"""
)
        XCTAssertEqual(accessibilityElement?.caretLocation, 41)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
        XCTAssertEqual(accessibilityElement?.selectedText, "W")
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
      
        XCTAssertEqual(accessibilityElement?.fileText.value, "gonna replace one of thosE😂️letters...")
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_in_normal_setting_it_replaces_an_uppercase_character_by_a_lowercase_one() {
        let textInAXFocusedElement = "gonna replace one of thosE😂️letters..."
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.B(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
      
        XCTAssertEqual(accessibilityElement?.fileText.value, "gonna replace one of those😂️letters...")
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }

}
