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
    
    // TODO: need to check what Vim does
//    func test_something_if_the_count_is_too_high() {
//        let text = "😀️e gonna move in there with count 🈹️ awww"
//        let element = AccessibilityTextElement(
//            role: .textField,
//            value: text,
//            length: 44,
//            caretLocation: 32,
//            selectedLength: 1,
//            selectedText: "u",
//            currentScreenLine: ScreenLine(
//                fullTextValue: text,
//                fullTextLength: 44,
//                number: 1,
//                start: 0,
//                end: 44
//            )!
//        )
//        
//        let returnedElement = applyMoveBeingTested(times: 69, on: element)
//
//        XCTAssertEqual(returnedElement?.caretLocation, 0)
//        XCTAssertEqual(returnedElement?.selectedLength, 3)
//        XCTAssertNil(returnedElement?.selectedText)
//    }
    
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
