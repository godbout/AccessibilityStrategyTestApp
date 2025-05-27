import XCTest
@testable import AccessibilityStrategy
import Common


class ASUI_VM_u_Tests: ASUI_VM_BaseTests {
    
    var vimEngineState = VimEngineState(visualStyle: .characterwise)

    private func applyMoveBeingTested(appFamily: AppFamily = .auto) -> AccessibilityTextElement {
        vimEngineState.appFamily = appFamily
        
        return applyMove { asVisualMode.u(on: $0, vimEngineState) }
    }

}


// Both
extension ASUI_VM_u_Tests {

    func test_that_it_changes_case_to_uppercase_for_the_selection() {
        let textInAXFocusedElement = """
all that VM d DOES
in characTerwi😂️e is deleting
the SElection!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested()

        XCTAssertEqual(accessibilityElement.fileText.value, """
all that VM d does
in characterwi😂️e is deleting
the sElection!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "d")
    }

}


// PGR and Electron
extension ASUI_VM_u_Tests {

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_in_UI_Elements_receptive_to_PGR() {
        let textInAXFocusedElement = """
all that VM d DOES
in characTerwi😂️e is deleting
the SElection!
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
all that VM d does
in characterwi😂️e is deleting
the sElection!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "d")
    }

    func test_that_when_it_is_called_in_PGR_Mode_it_does_delete_or_paste_and_once_only_in_UI_Elements_NOT_receptive_to_PGR() {
        let textInAXFocusedElement = """
all that VM d DOES
in characTerwi😂️e is deleting
the SElection!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        let accessibilityElement = applyMoveBeingTested(appFamily: .pgR)

        XCTAssertEqual(accessibilityElement.fileText.value, """
all that VM d does
in characterwi😂️e is deleting
the sElection!
"""
        )
        XCTAssertEqual(accessibilityElement.caretLocation, 14)
        XCTAssertEqual(accessibilityElement.selectedLength, 1)
        XCTAssertEqual(accessibilityElement.selectedText, "d")
    }
    
    func test_that_when_it_is_called_in_PGR_Mode_it_does_not_overwrite_the_Clipboard() {
        let textInAXFocusedElement = """
all that VM d DOES
in characTerwi😂️e is deleting
the SElection!
"""
        app.webViews.textViews.firstMatch.tap()
        app.webViews.textViews.firstMatch.typeText(textInAXFocusedElement)
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(times: 4, on: $0) }
        applyMove { asVisualMode.vFromNormalMode(on: $0) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        applyMove { asVisualMode.j(on: $0, vimEngineState) }
        applyMove { asVisualMode.b(on: $0, vimEngineState) }
        
        copyToClipboard(text: "some fake shit")
        
        _ = applyMoveBeingTested(appFamily: .pgR)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "some fake shit")
    }

}
