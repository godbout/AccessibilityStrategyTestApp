import XCTest
@testable import AccessibilityStrategy
import Common


// in the past ddg$ would call ccg$ but they actually act differently on ELs so now ddg$ is on its own
// and we have all the required tests here.
class ASUI_NM_ddgDollarSign_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.ddgDollarSign(using: $0.currentFileLine, on: $0, &vimEngineState) }
    }
    
}


// TextFields and TextViews
extension ASUI_NM_ddgDollarSign_Tests {
    
    func test_that_if_a_file_line_does_not_end_with_a_Newline_it_deletes_from_the_caret_to_the_end_of_the_line() {
        let textInAXFocusedElement = "this time the line will not end with a linefeed so C should delete from the caret till the end!"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.w(times: 2, on: $0) }
        applyMove { asNormalMode.l(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "this time t")
        XCTAssertEqual(accessibilityElement.caretLocation, 10)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "t")
    }
    
}

// TextViews
extension ASUI_NM_ddgDollarSign_Tests {
    
    func test_that_if_a_file_line_ends_with_a_Newline_it_deletes_from_the_caret_to_before_that_Newline() {
        let textInAXFocusedElement = """
C will now work with file lines and is supposed to del☀️te from the caret ☀️ to before the linefeed
and of course this is in the case there is a linefeed at the end of the line.
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(times: 3, to: "t", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
C will now work with file lines and is supposed to del☀️
and of course this is in the case there is a linefeed at the end of the line.
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 54)
        XCTAssertEqual(accessibilityElement.selectedLength, 2)
        XCTAssertEqual(accessibilityElement.selectedText, "☀️")
    }
    
    func test_that_it_does_not_delete_the_Newline_even_for_an_EmptyLine() {
        let textInAXFocusedElement = """
now we have an empty line and C should behave

and not delete that fucking shit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
now we have an empty line and C should behave

and not delete that fucking shit
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 46)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "\n")
    }

}
