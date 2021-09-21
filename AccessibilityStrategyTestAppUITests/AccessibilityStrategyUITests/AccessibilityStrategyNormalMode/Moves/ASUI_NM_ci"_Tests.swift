import XCTest
import KeyCombination
import AccessibilityStrategy


// just for extra careful. but all can and is tested in UT.
// this is more a legacy test that i don't wanna remove :D
class UIASNM_ciDoubleQuote_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested() -> AccessibilityTextElement? {
        return applyMove { asNormalMode.ciDoubleQuote(on: $0) }
    }

}


extension UIASNM_ciDoubleQuote_Tests {

    func test_that_in_normal_setting_it_can_delete_the_content_between_double_quotes() {
        let textInAXFocusedElement = """
hehe there's gonna be some "double quotes" in that shit
"""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
            
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement?.text.value, "hehe there's gonna be some \"\" in that shit")
    }

}
