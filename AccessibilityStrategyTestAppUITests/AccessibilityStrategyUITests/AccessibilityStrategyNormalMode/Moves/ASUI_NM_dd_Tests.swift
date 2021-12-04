import XCTest
@testable import AccessibilityStrategy


class ASUI_NM_dd_Tests: ASUI_NM_BaseTests {
    
    private func applyMoveBeingTested(pgR: Bool = false) -> AccessibilityTextElement? {
        return applyMove { asNormalMode.dd(on: $0, pgR: pgR) }
    }
    
}


// TextFields
extension ASUI_NM_dd_Tests {
    
    func test_that_in_normal_setting_it_deletes_the_whole_line() {
        let textInAXFocusedElement = "this is a line to be deleted"
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "")        
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }
    
    func test_that_if_the_line_is_empty_it_does_not_crash() {
        let textInAXFocusedElement = ""
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(textInAXFocusedElement)
       
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "")        
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 0)
    }

}


// TextViews
extension ASUI_NM_dd_Tests {
    
    func test_that_it_normal_setting_it_deletes_the_whole_line() {
        let textInAXFocusedElement = """
the caret should go down
2️⃣️ the next line
somehow
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "2️⃣️ the next line\nsomehow")
        XCTAssertEqual(accessibilityElement?.caretLocation, 0)
        XCTAssertEqual(accessibilityElement?.selectedLength, 4)
    }
    
    func test_that_it_skips_the_spaces_on_the_next_line_and_that_it_therefore_keeps_the_indentation() {
        let textInAXFocusedElement = """
if someBullshit == true {
    😀️s = yeah
}
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "    😀️s = yeah\n}")
        XCTAssertEqual(accessibilityElement?.caretLocation, 4)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_it_skips_the_tabs_on_the_next_line_and_that_it_therefore_keeps_the_indentation() {
        let textInAXFocusedElement = """
if someBullshit == true {
\tbs = yeah
}
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.e(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "\tbs = yeah\n}")        
        XCTAssertEqual(accessibilityElement?.caretLocation, 1)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_when_it_deletes_a_line_it_ends_up_at_the_correct_indentation_on_the_next_line() {
        let textInAXFocusedElement = """
for example
  🇫🇷️t should stop
after the two spaces
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
      
        applyMove { asNormalMode.gg(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "  🇫🇷️t should stop\nafter the two spaces")
        XCTAssertEqual(accessibilityElement?.caretLocation, 2)            
        XCTAssertEqual(accessibilityElement?.selectedLength, 5)
    }
    
    func test_that_if_on_the_last_line_it_deletes_the_line_and_goes_up_to_the_first_non_blank_of_the_previous_line() {
        let textInAXFocusedElement = """
this one
    🌲️s a tough
one
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, "this one\n    🌲️s a tough")
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)   
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
    func test_that_the_caret_ends_up_at_the_next_line_end_limit_if_the_next_line_is_just_made_out_of_non_blank_characters() {
        let textInAXFocusedElement = """
if the next line is just blank characters
then there is no firstNonBlank so we need
          
to stop at the end limit of the line
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.zero(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        applyMove { asNormalMode.ge(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
if the next line is just blank characters
          
to stop at the end limit of the line
"""
        )        
        XCTAssertEqual(accessibilityElement?.caretLocation, 51)
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_if_the_next_line_is_only_blanks_the_caret_goes_to_the_limit_of_the_line_before_the_linefeed() {
        let textInAXFocusedElement = """
we gonna use VM
dd here and we suppose
      to go to non blank of the line
         
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
       
        applyMove { asNormalMode.h(on: $0) }
        applyMove { asNormalMode.gk(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
we gonna use VM
dd here and we suppose
         
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 47)    
        XCTAssertEqual(accessibilityElement?.selectedLength, 1)
    }
    
    func test_that_if_the_caret_is_at_the_last_character_of_the_TextElement_and_on_an_empty_line_it_works_and_the_caret_goes_to_the_relevant_position() {
        let textInAXFocusedElement = """
caret is on its
own empty
    😄️ine

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested()
        
        XCTAssertEqual(accessibilityElement?.fileText.value, """
caret is on its
own empty
    😄️ine
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 30)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
    }
    
}


// PGR
// there's one other "case" where PGR is called but that one can't be tested.
// see NM dd implementation. will be clear.
extension ASUI_NM_dd_Tests {
    
    func test_that_if_there_is_a_next_line_when_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
for example
  🇫🇷️t should stop
after the two spaces
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.gg(on: $0) }
        applyMove { asNormalMode.w(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)
        

        XCTAssertEqual(accessibilityElement?.fileText.value, """
    🇫🇷️t should stop
after the two spaces
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 4)
        XCTAssertEqual(accessibilityElement?.selectedLength, 5)
        XCTAssertEqual(accessibilityElement?.selectedText, "🇫🇷️")
    }

    func test_that_if_there_is_no_next_line_and_there_is_a_previous_line_when_there_is_a_next_line_and_it_is_called_in_PGR_mode_it_tricks_the_system_and_eventually_modifies_text() {
        let textInAXFocusedElement = """
this one
    🌲️s a tough
one
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)

        applyMove { asNormalMode.l(on: $0) }
        let accessibilityElement = applyMoveBeingTested(pgR: true)

        XCTAssertEqual(accessibilityElement?.fileText.value, """
this one
    🌲️s a toug
"""
        )
        XCTAssertEqual(accessibilityElement?.caretLocation, 13)
        XCTAssertEqual(accessibilityElement?.selectedLength, 3)
        XCTAssertEqual(accessibilityElement?.selectedText, "🌲️")
    }
    
}
