@testable import AccessibilityStrategy
import XCTest


class FT_nextUnmatched_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, using closingBlock: ClosingBlockType, after caretLocation: Int) -> Int? {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.nextUnmatched(closingBlock, after: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_nextUnmatched_Tests {
    
    func test_that_it_goes_to_the_next_unmatched_bracket_where_there_is_only_one() {
        let text = "ok so an easy test because i can't wrap ] my head around the recursive func lol"
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightBracket, after: 11)
        
        XCTAssertEqual(nextUnmatchedLocation, 40)
    }
    
    func test_that_in_normal_setting_it_goes_to_the_next_unmatched_bracket() {
        let text = "hello{h}ell}"
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightBrace, after: 2)
        
        XCTAssertEqual(nextUnmatchedLocation, 11)
    }
    
    func test_that_if_there_is_no_right_bracket_it_returns_nil() {
        let text = "no left brace in here move along"
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightBrace, after: 19)
        
        XCTAssertNil(nextUnmatchedLocation)
    }
    
    func test_that_if_there_are_only_matched_brackets_it_returns_nil() {
        let text = "full of ( ) matched ( braces ) "
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightParenthesis, after: 6)
        
        XCTAssertNil(nextUnmatchedLocation)
    }
      
    func test_that_if_the_caret_is_right_before_a_bracket_it_will_still_go_to_the_next_unmatched_one() {
        let text = """
so there's a ) here
and another ) here
"""
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightParenthesis, after: 13)

        XCTAssertEqual(nextUnmatchedLocation, 32)
    }
    
    func test_that_it_works_with_a_lot_of_brackets() {
        let text = "(   (    (   )   )     )"
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightParenthesis, after: 0)

        XCTAssertEqual(nextUnmatchedLocation, 23)
    }
    
    func test_that_in_normal_cases_it_works_hehe() {
        let text = "a couple of ( (( ))))  ) O_o"
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightParenthesis, after: 14)
        
        XCTAssertEqual(nextUnmatchedLocation, 18)
    }
    
    func test_another_complicated_one_to_see_if_the_algorithm_works() {
        let text = "{{{          }}         {{{{ }}}}}}}}"
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightBrace, after: 20)
        
        XCTAssertEqual(nextUnmatchedLocation, 33)
    }
    
    func test_that_if_the_text_is_empty_it_returns_nil() {
        let text = ""
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightBrace, after: 0)
        
        XCTAssertNil(nextUnmatchedLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FT_nextUnmatched_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emyeah 🤨️{🤨️ coz🤨️🤨️ the text 🤨️🤨️functions don't care about😂️🤨️🤨️🤨️ the len>gth but 🦋️ the move"
        
        let nextUnmatchedLocation = applyFuncBeingTested(on: text, using: .rightChevron, after: 6)
        
        XCTAssertEqual(nextUnmatchedLocation, 86)
    }
    
}
