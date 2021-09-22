@testable import AccessibilityStrategy
import XCTest


class nextUnmatchedTests: TextEngineBaseTests {}


// Both
extension nextUnmatchedTests {
    
    func test_that_it_goes_to_the_next_unmatched_bracket_where_there_is_only_one() {
        let text = "ok so an easy test because i can't wrap } my head around the recursive func lol"
        
        let nextUnmatchedLocation = textEngine.nextUnmatched("}", after: 11, in: TextEngineText(from: text))
        
        XCTAssertEqual(nextUnmatchedLocation, 40)
    }
    
    func test_that_in_normal_setting_it_goes_to_the_next_unmatched_bracket() {
        let text = "hello{h}ell}"
        
        let nextUnmatchedLocation = textEngine.nextUnmatched("}", after: 2, in: TextEngineText(from: text))
        
        XCTAssertEqual(nextUnmatchedLocation, 11)
    }
    
    func test_that_if_there_is_no_right_bracket_it_returns_nil() {
        let text = "no left brace in here move along"
        
        let nextUnmatchedLocation = textEngine.nextUnmatched(")", after: 19, in: TextEngineText(from: text))
        
        XCTAssertNil(nextUnmatchedLocation)
    }
    
    func test_that_if_there_are_only_matched_brackets_it_returns_nil() {
        let text = "full of ( ) matched ( braces ) "
        
        let nextUnmatchedLocation = textEngine.nextUnmatched(")", after: 6, in: TextEngineText(from: text))
        
        XCTAssertNil(nextUnmatchedLocation)
    }
      
    func test_that_if_the_caret_is_right_before_a_bracket_it_will_still_go_to_the_next_unmatched_one() {
        let text = """
so there's a ) here
and another ) here
"""
        let nextUnmatchedLocation = textEngine.nextUnmatched(")", after: 13, in: TextEngineText(from: text))
        
        XCTAssertEqual(nextUnmatchedLocation, 32)
    }
    
    func test_that_it_works_with_a_lot_of_brackets() {
        let text = "(   (    (   )   )     )"
        
        let nextUnmatchedLocation = textEngine.nextUnmatched(")", after: 0, in: TextEngineText(from: text))
        
        XCTAssertEqual(nextUnmatchedLocation, 23)
    }
    
    func test_that_in_normal_cases_it_works_hehe() {
        let text = "a couple of ( (( ))))  ) O_o"
        
        let nextUnmatchedLocation = textEngine.nextUnmatched(")", after: 14, in: TextEngineText(from: text))
        
        XCTAssertEqual(nextUnmatchedLocation, 18)
    }
    
    func test_another_complicated_one_to_see_if_the_algorithm_works() {
        let text = "{{{          }}         {{{{ }}}}}}}}"
        
        let nextUnmatchedLocation = textEngine.nextUnmatched("}", after: 20, in: TextEngineText(from: text))
        
        XCTAssertEqual(nextUnmatchedLocation, 33)
    }
    
    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""
        
        let nextUnmatchedLocation = textEngine.nextUnmatched("}", after: 0, in: TextEngineText(from: text))
        
        XCTAssertNil(nextUnmatchedLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension nextUnmatchedTests {
    
    func test_that_it_handles_emojis() {
        let text = "emyeah 🤨️{🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't care about😂️🤨️🤨️🤨️ the len)gth but 🦋️ the move"
        
        let nextUnmatchedLocation = textEngine.nextUnmatched(")", after: 6, in: TextEngineText(from: text))
        
        XCTAssertEqual(nextUnmatchedLocation, 86)
    }
    
}

