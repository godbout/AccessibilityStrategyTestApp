import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_NM_ch_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(times count: Int = 1, appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        var vimEngineState = VimEngineState(appFamily: appFamily)
        
        return applyMove { asNormalMode.ch(times: count, on: $0, &vimEngineState) }
    }
    
}


// count
extension ASUI_NM_ch_Tests {
    
    func test_that_it_implements_the_count_system() {
        let textInAXFocusedElement = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.f(to: "u", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 4)

        XCTAssertEqual(accessibilityElement.fileText.value, """
testing witunt
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 11)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
    func test_that_if_the_count_is_too_high_it_stops_at_the_start_of_the_line() {
        let textInAXFocusedElement = """
testing with count
should be awesome to use
  😂️ctually nobody uses counts
LMAO
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 3, on: $0) }
        applyMove { asNormalMode.f(to: "u", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(times: 69)

        XCTAssertEqual(accessibilityElement.fileText.value, """
testing with count
should be awesome to use
ually nobody uses counts
LMAO
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 44)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// Both
extension ASUI_NM_ch_Tests {
    
    func test_that_in_normal_setting_it_deletes_the_character_before_the_caretLocation() {
        let textInAXFocusedElement = " ch to delete a char😂️cter on the left"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.F(to: "c", on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, " ch to delete a charcter on the left")
        XCTAssertEqual(accessibilityElement.caretLocation, 20)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
    
}


// TextViews
extension ASUI_NM_ch_Tests {
    
    func test_that_if_the_caret_is_at_the_start_of_the_file_line_it_does_not_delete_nor_move_and_deselects_text() {
        let textInAXFocusedElement = """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(times: 2, on: $0) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
so we're at the start of the second line
and a shouldn't get deleted and
we should stay there
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 41)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
        XCTAssertEqual(accessibilityElement.selectedText, "")
    }
        
}


// PGR and Electron
extension ASUI_NM_ch_Tests {

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = "ch should delete the correct character"
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "ch should delete the correctcharacter")
        XCTAssertEqual(accessibilityElement.caretLocation, 28)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }    
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = "ch should delete the correct character"
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.b(on: $0) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, "ch should delete the correctcharacter")
        XCTAssertEqual(accessibilityElement.caretLocation, 28)
        XCTAssertEqual(accessibilityElement.selectedLength, 0)
    }    
    
}
