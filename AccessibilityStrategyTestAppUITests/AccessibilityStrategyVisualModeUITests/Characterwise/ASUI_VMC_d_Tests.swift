import XCTest
import KeyCombination
import AccessibilityStrategy


class ASUI_VMC_d_Tests: ASUI_VM_BaseTests {}


extension ASUI_VMC_d_Tests {
    
    func test_that_it_simply_deletes_the_selection() {
        let textInAXFocusedElement = """
all that VM d does
in characterwise is deleting
the selection!
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        KindaVimEngine.shared.enterNormalMode()
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .k))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .v))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .k))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .l))
        
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .d))
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.value, """
all that VM d se is deleting
the selection!
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 14)        
    }
    
    func test_that_if_there_is_only_one_character_on_a_line_deleting_it_stays_on_the_line_and_does_not_go_to_the_linefeed_of_the_above_line() {
        let textInAXFocusedElement = """
if deleting the last character of
x
should go back to line end limit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        KindaVimEngine.shared.enterNormalMode()
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .zero))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .v))
        
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .d))
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.value, """
if deleting the last character of

should go back to line end limit
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 34)         
    }
    
    func test_that_if_the_caret_is_on_an_empty_line_it_deletes_the_linefeed_and_stick_the_next_line_up() {
        let textInAXFocusedElement = """
there's gonna be an empty line

right above
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        KindaVimEngine.shared.enterNormalMode()
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .v))
        
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .d))
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.value, """
there's gonna be an empty line
right above
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 31)         
    }
    
    func test_that_when_the_selection_spans_on_a_single_line_if_after_deletion_the_caret_ends_up_after_the_line_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = """
if deleting the last character of
a line before the linefeed the caret
should go back to line end limit
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: [])
        KindaVimEngine.shared.enterNormalMode()
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .e))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .v))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .b))
        
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .d))
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.value, """
if deleting the last character of
a line before the linefeed the 
should go back to line end limit
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 64)
    }
    
    func test_that_when_the_selection_spans_on_multiple_lines_if_after_deletion_the_caret_ends_up_after_the_line_limit_then_it_is_moved_back_to_the_end_limit() {
        let textInAXFocusedElement = """
same as above
but on multiple
lines this time
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        KindaVimEngine.shared.enterNormalMode()
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .k))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .k))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .v))
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .j))
        
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .d))
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.value, """
same as abov
lines this time
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 11)
    }    
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_it_works_and_the_caret_goes_to_the_relevant_position() {
        let textInAXFocusedElement = """
caret is on its
own empty
    line

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        KindaVimEngine.shared.enterNormalMode()
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .v))
        app.textViews.firstMatch.typeKey(.rightArrow, modifierFlags: [])
        
        KindaVimEngine.shared.handle(keyCombination: KeyCombination(key: .d))
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.value, """
caret is on its
own empty
    line

"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 35)
    }
    
}


// emojis
// as far as i saw from the code there's no need to test emojis here
extension ASUI_VMC_d_Tests {}
