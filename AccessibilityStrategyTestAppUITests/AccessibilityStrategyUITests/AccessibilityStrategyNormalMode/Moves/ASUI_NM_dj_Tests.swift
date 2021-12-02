import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_dj_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.dj(on: $0, pgR: pgR) }
    }
    
}


// Both
extension ASUI_NM_dj_Tests {
    
    func test_that_if_there_is_only_one_line_it_does_not_do_anything() {
        let textInAXFocusedElement = "one line is not enough for dj 😀️"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "one line is not enough for dj 😀️")        
        XCTAssertEqual(accessibilityElement?.caretLocation, 30)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}


// TextViews
extension ASUI_NM_dj_Tests {
    
    func test_that_it_can_delete_two_lines() {
        let textInAXFocusedElement = """
like this line and the following
one should disappear
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "")        
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_if_there_are_more_than_two_lines_the_caret_goes_to_the_first_non_blank_of_the_third_line() {
        let textInAXFocusedElement = """
now 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
becau🤡️se it w🤡️🤡️ill go 🤡️to the🤡️ next
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        )        
        XCTAssertEqual(accessibilityElement?.caretLocation, 5)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_if_what_we_deleted_are_the_two_last_lines_then_the_caret_goes_to_the_first_non_blank_of_what_is_now_the_newly_last_line() {
        let textInAXFocusedElement = """
   😚️ow 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
becau🤡️se it w🤡️🤡️ill go 🤡️to the🤡️ next
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
   😚️ow 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
"""
        )        
        XCTAssertEqual(accessibilityElement?.caretLocation, 3)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}
 
