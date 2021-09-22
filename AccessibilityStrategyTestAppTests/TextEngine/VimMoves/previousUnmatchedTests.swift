@testable import AccessibilityStrategy
import XCTest


class previousUnmatchedTests: TextEngineBaseTests {}


// Both
extension previousUnmatchedTests {
        
    func test_that_it_can_move_to_a_lonely_bracket() {
        let text = "that's a lonely { right here "
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("{", before: 26, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 16)
    }
    
    func test_that_in_normal_setting_it_goes_to_the_previous_unmatched_bracket() {
        let text = "that one's { gonna sting { lo"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("{", before: 29, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 25)
    }
    
    func test_that_it_skips_matched_brackets() {
        let text = "a { tougher { one } i believe"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("{", before: 26, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 2)
    }
    
    func test_that_if_it_cannot_find_a_previous_unmatched_bracket_it_returns_nil() {
        let text = "no left brace in here move along"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("(", before: 19, in: text)
        
        XCTAssertNil(previousUnmatchedLocation)
    }
    
    func test_that_if_there_are_only_matched_brackets_it_returns_nil() {
        let text = "full of ( ) matched ( braces )"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("(", before: 30, in: text)

        XCTAssertNil(previousUnmatchedLocation)
    }
    
    func test_that_if_the_caret_is_right_before_a_bracket_it_will_still_go_to_the_previous_one() {
        let text = """
caret just ( before
the second brace ( yes
"""
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("(", before: 37, in: text)
        
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
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("{", before: 41, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 40)
    }
    
    func test_that_it_works_with_a_lot_of_brackets_lol() {
        let text = "(   (    (   )   )     "
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("(", before: 23, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 0)
    }
    
    func test_that_it_does_not_explode_with_string_out_of_bounds_like_before() {
        let text = "that one's { gonna s}ting { lo"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("{", before: 30, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 26)
    }
    
    func test_whatever_to_sleep_better_at_night() {
        let text = " a couple of ( ( )"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("(", before: 15, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 13)
    }
    
    func test_again_that_in_normal_cases_it_works_hehe_because_of_multiple_past_failures() {
        let text = "a couple of ( (( ))))  ) O_o"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("(", before: 19, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 12)
    }
    
    func test_another_complicated_one_to_see_if_the_algorithm_works() {
        let text = "{{{          }         {{{{ }}}}}}}}"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("{", before: 17, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 1)
    }
    
    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("{", before: 0, in: text)
        
        XCTAssertNil(previousUnmatchedLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension previousUnmatchedTests {
    
    func test_that_it_handles_emojis() {
        let text = "emyeah 🤨️{🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't care about😂️🤨️🤨️🤨️ the length but 🦋️ the move"
        
        let previousUnmatchedLocation = textEngine.previousUnmatched("{", before: 103, in: text)
        
        XCTAssertEqual(previousUnmatchedLocation, 10)
    }
    
}
