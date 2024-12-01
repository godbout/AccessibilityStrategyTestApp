import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_dk_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.dk(on: $0, &vimEngineState) }
    }
    
}


// Both
extension ASUI_NM_dk_Tests {
    
    func test_that_if_there_is_only_one_line_it_does_not_do_anything() {
        let textInAXFocusedElement = "one line is not enough for dk"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.h(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "one line is not enough for dk")        
        XCTAssertEqual(accessibilityElement.caretLocation, 28)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
    }
    
}


// TextViews
extension ASUI_NM_dk_Tests {
    
    func test_that_it_can_delete_two_lines() {
        let textInAXFocusedElement = """
like this line and the following
one should disappear
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "")        
        XCTAssertEqual(accessibilityElement.caretLocation, 0)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
    func test_that_if_there_are_more_than_two_lines_the_caret_goes_to_the_first_non_blank_of_the_third_line() {
        let textInAXFocusedElement = """
now 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
becau🤡️se it w🤡️🤡️ill go 🤡️to the🤡️ next
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        )        
        XCTAssertEqual(accessibilityElement.caretLocation, 5)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_if_what_we_deleted_are_the_two_last_lines_then_the_caret_goes_to_the_first_non_blank_of_what_is_now_the_newly_last_line() {
        let textInAXFocusedElement = """
   😚️ow 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
becau🤡️se it w🤡️🤡️ill go 🤡️to the🤡️ next
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
   😚️ow 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
"""
        )        
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}


// PGR and Electron
extension ASUI_NM_dk_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
   😚️ow 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
becau🤡️se it w🤡️🤡️ill go 🤡️to the🤡️ next
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
   😚️ow 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
"""
        )        
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
   😚️ow 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
becau🤡️se it w🤡️🤡️ill go 🤡️to the🤡️ next
     🤡️o🤡️n b🤡️lank of 🤡️this line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
   😚️ow 🤡️🤡️this is🤡️ get🤡️🤡️ting cool
"""
        )        
        XCTAssertEqual(accessibilityElement.caretLocation, 3)
        XCTAssertEqual(accessibilityElement.selectedLength, 3)
    }
    
}
