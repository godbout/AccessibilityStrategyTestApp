import XCTest
@testable import AccessibilityStrategy
import Common


// see ddg$ for blah blah
class ASUI_NM_dg$_Tests: ASUI_NM_BaseTests {

    private func applyMoveBeingTested() -> AccessibilityTextElement {
        var state = VimEngineState()
        
        return applyMove { asNormalMode.dgDollarSign(on: $0, &state) }
    }
    
}


// test that we pass the right LineType parameter to the superman func
extension ASUI_NM_dg$_Tests {
        
    func test_that_a_ScreenLine_and_not_a_FileLine_is_sent_as_parameter_to_the_superman_move() {
        let textInAXFocusedElement = """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.G(on: $0) }
        applyMove { asNormalMode.f(times: 3, to: "e", on: $0) }
        let accessibilityElement = applyMoveBeingTested()
                
        XCTAssertEqual(accessibilityElement.fileText.value, """
C will now work with file lines and is supposed to delete from the caret ☀️ to before the linefeed
and of course this is in the caslinefeed at the end of the line.
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 131)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "l")
    }
    
}
