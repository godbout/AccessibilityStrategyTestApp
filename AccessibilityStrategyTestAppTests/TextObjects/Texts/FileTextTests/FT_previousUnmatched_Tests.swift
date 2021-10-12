@testable import AccessibilityStrategy
import XCTest


class FT_previousUnmatched_Tests: XCTestCase {}


// Both
extension FT_previousUnmatched_Tests {
        
    func test_that_it_can_move_to_a_lonely_bracket() {
        let text = "that's a lonely { right here "
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("{", before: 25)
        
        XCTAssertEqual(previousUnmatchedLocation, 16)
    }
    
    func test_that_in_normal_setting_it_goes_to_the_previous_unmatched_bracket() {
        let text = "that one's { gonna sting { lo"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("{", before: 29)
        
        XCTAssertEqual(previousUnmatchedLocation, 25)
    }
    
    func test_that_it_skips_matched_brackets() {
        let text = "a { tougher { one } i believe"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("{", before: 28)
        
        XCTAssertEqual(previousUnmatchedLocation, 2)
    }
    
    func test_that_if_it_cannot_find_a_previous_unmatched_bracket_it_returns_nil() {
        let text = "no left brace in here move along"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("(", before: 20)
        
        XCTAssertNil(previousUnmatchedLocation)
    }
    
    func test_that_if_there_are_only_matched_brackets_it_returns_nil() {
        let text = "full of ( ) matched ( braces )"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("(", before: 30)
        
        XCTAssertNil(previousUnmatchedLocation)
    }
    
    func test_that_if_the_caret_is_right_before_a_bracket_it_will_still_go_to_the_previous_one() {
        let text = """
caret just ( before
the second brace ( yes
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("(", before: 37)
        
        XCTAssertEqual(previousUnmatchedLocation, 11)
    }
    
    func test_that_if_the_caret_is_right_after_a_left_bracket_it_still_goes_to_that_bracket() {
        let text = """
caret
is right after
the { second
brace { yes
again
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("{", before: 41)
        
        XCTAssertEqual(previousUnmatchedLocation, 40)
    }
    
    func test_that_it_works_with_a_lot_of_brackets_lol() {
        let text = "(   (    (   )   )     "
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("(", before: 23)
        
        XCTAssertEqual(previousUnmatchedLocation, 0)
    }
    
    func test_that_it_does_not_explode_with_string_out_of_bounds_like_before() {
        let text = "that one's { gonna s}ting { lo"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("{", before: 28)
        
        XCTAssertEqual(previousUnmatchedLocation, 26)
    }
    
    func test_whatever_to_sleep_better_at_night() {
        let text = " a couple of ( ( )"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("(", before: 15)
        
        XCTAssertEqual(previousUnmatchedLocation, 13)
    }
    
    func test_again_that_in_normal_cases_it_works_hehe_because_of_multiple_past_failures() {
        let text = "a couple of ( (( ))))  ) O_o"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("(", before: 19)
        
        XCTAssertEqual(previousUnmatchedLocation, 12)
    }
    
    func test_another_complicated_one_to_see_if_the_algorithm_works() {
        let text = "{{{          }         {{{{ }}}}}}}}"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("{", before: 17)
        
        XCTAssertEqual(previousUnmatchedLocation, 1)
    }
    
    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("{", before: 0)
        
        XCTAssertNil(previousUnmatchedLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_previousUnmatched_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emyeah 🤨️{🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't care about😂️🤨️🤨️🤨️ the length but 🦋️ the move"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let previousUnmatchedLocation = fileText.previousUnmatched("{", before: 103)
        
        XCTAssertEqual(previousUnmatchedLocation, 10)
    }
    
}
