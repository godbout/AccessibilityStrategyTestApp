@testable import AccessibilityStrategy
import XCTest


// VM Y acts the same when in VMC and VML. both C and L are tests here.
// the tests are similar to VML y, because VM Y is NM V + VM y
class ASUT_VM_Y__Tests: ASVM_BaseTests {
    
    private func applyMove(on element: AccessibilityTextElement?) -> AccessibilityTextElement? {
        return asVisualMode.Y(on: element)
    }
    
}


// Both
extension ASUT_VM_Y__Tests {
    
    func test_that_for_TextFields_it_yanks_the_whole_line() {
        let text = "a whole line entirely for VM V and VM y"
        let element = AccessibilityTextElement(
            role: .textField,
            value: text,
            length: 39,
            caretLocation: 19,
            selectedLength: 5,
            selectedText: "ly fo",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 39,
                number: 1,
                start: 0,
                end: 39
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), "a whole line entirely for VM V and VM y")   
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// TextViews
extension ASUT_VM_Y__Tests {
    
    func test_that_for_TextViews_it_yanks_the_selected_lines() {
        let text = """
gonna be dealing
with VM V over
why the fuck am
i writing this?
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 63,
            caretLocation: 20,
            selectedLength: 20,
            selectedText: "h VM V over\nwhy the ",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 63,
                number: 2,
                start: 17,
                end: 32
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(NSPasteboard.general.string(forType: .string), """
with VM V over
why the fuck am\n
"""
        )
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
    func test_that_after_yanking_it_gets_back_to_the_caret_position() {
        let text = """
yes even in multilne
it goes back to
the crazy caret location and
not the anchor!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 81,
            caretLocation: 21,
            selectedLength: 45,
            selectedText: """
it goes back to
the crazy caret location and
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 81,
                number: 2,
                start: 21,
                end: 37
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 21)
        XCTAssertEqual(returnedElement?.selectedLength, 1)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}


// emojis
extension ASUT_VM_Y__Tests {
    
    func test_that_it_handles_emojis() {
        let text = """
yes even in multilne
🔥️t goes back to
the crazy caret location and
not the anchor!
"""
        let element = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 83,
            caretLocation: 21,
            selectedLength: 47,
            selectedText: """
🔥️t goes back to
the crazy caret location and
""",
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 83,
                number: 2,
                start: 21,
                end: 39
            )!
        )
        
        let returnedElement = applyMove(on: element)
        
        XCTAssertEqual(returnedElement?.caretLocation, 21)
        XCTAssertEqual(returnedElement?.selectedLength, 3)
        XCTAssertNil(returnedElement?.selectedText)
    }
    
}
