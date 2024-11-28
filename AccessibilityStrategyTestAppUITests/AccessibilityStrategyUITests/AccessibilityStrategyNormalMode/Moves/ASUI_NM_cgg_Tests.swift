import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_cgg_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var state = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.cgg(on: $0, &state) }
    }
    
}


// Both
extension ASUI_NM_cgg_Tests {
    
    func test_that_it_deletes_the_line_up_to_the_firstNonBlankLimit() {
        let textInAXFocusedElement = "    this is a single line ‼️‼️‼️"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "s", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, "    ")
        XCTAssertEqual(accessibilityElement.caretLocation, 4)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// TextViews
extension ASUI_NM_cgg_Tests {
    
    // this test contains blanks
    func test_that_it_deletes_from_the_firstNonBlankLimit_of_the_current_line_to_the_end_of_the_TextView() {
        let textInAXFocusedElement = """
  blah blah some line
some more
haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 3, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
  
need to deal with
those faces 🥺️☹️😂️

"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 2)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// PGR and Electron
extension ASUI_NM_cgg_Tests {
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
  blah blah some line
some more
haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.f(to: "g", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
  
need to deal with
those faces 🥺️☹️😂️

"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 2)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
  blah blah some line
some more
haha geh
need to deal with
those faces 🥺️☹️😂️

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.gj(on: $0) }
        applyMove { asNormalMode.f(to: "g", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(accessibilityElement.fileText.value, """
  
need to deal with
those faces 🥺️☹️😂️

"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 2)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }
    
}
