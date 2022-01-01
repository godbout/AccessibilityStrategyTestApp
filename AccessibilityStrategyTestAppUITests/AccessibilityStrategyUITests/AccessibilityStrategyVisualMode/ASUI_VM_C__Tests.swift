import XCTest
@testable import AccessibilityStrategy


// VM C behaves the same in C and L
// also yes, tests are the same as VML c, because basically doing a VM C is like doing
// a NM V + VM c. implementations are different though has VM C needs to calculate start and end of
// lines, while VM c doesn't need as the selection is provided by NM V.
class ASUI_VM_C__Tests: ASUI_VM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asVisualMode.C(on: $0, pgR: pgR)}
    }

}


// copy deleted text
extension ASUI_VM_C__Tests {
    
    func test_that_it_copies_the_deleted_text_in_the_pasteboard() {
        let textInAXFocusedElement = """
VM c in Linewise
will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        applyMove { asVisualMode.vForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        copyToClipboard(text: "some fake shit")
        _ = applyMoveBeingTested()
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
will delete the selected lines
but the below line will not go up\n
"""
        )
    }
}


// Both
extension ASUI_VM_C__Tests {

    func test_that_in_normal_setting_it_deletes_the_selected_lines_but_without_the_last_linefeed_of_the_selection_if_any() {
        let textInAXFocusedElement = """
VM c in Linewise
will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
VM c in Linewise

at least if we're not at the end of the text
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 17)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    } 
    
    func test_that_it_keeps_the_indentation_of_the_first_selected_line_when_it_is_a_blank_line() {
        let textInAXFocusedElement = """
VM c in Linewise
         
but the below line will not go up
at least if we're not at the end of the text
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
VM c in Linewise
         
at least if we're not at the end of the text
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 26)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    } 
    
    func test_that_it_keeps_the_indentation_of_the_first_selected_line_when_it_is_not_a_blank_line() {
        let textInAXFocusedElement = """
VM c in Linewise
   will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
VM c in Linewise
   
at least if we're not at the end of the text
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 20)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    } 

}


// PGR
extension ASUI_VM_C__Tests {
    
    func test_that_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
VM c in Linewise
will delete the selected lines
but the below line will not go up
at least if we're not at the end of the text
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.j(on: $0) }
        applyMove { asVisualMode.VForEnteringFromNormalMode(on: $0) }
        applyMove { asVisualMode.jForVisualStyleLinewise(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
VM c in Linewise
at least if we're not at the end of the text
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 16)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
        XCTAssertEqual(accessibilityElement?.selectedText, "")
    }
    
}
