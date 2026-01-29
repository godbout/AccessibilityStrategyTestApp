@testable import AccessibilityStrategy
import XCTest


class FT_aSentence_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.aSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_aSentence_NormalSetting_Tests {

    func test_that_if_the_text_is_just_one_word_then_it_returns_the_whole_text_lol() {
        let text = "dumb"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 4) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_beginning_of_the_next_sentence_including_the_blank_before_it() {
        let text = "dumb. and dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 6) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_beginning_of_the_next_sentence_including_the_blanks_before_it() {
        let text = "dumb.                      and dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 27) 
    }
        
    func test_that_for_the_first_sentence_of_the_text_it_does_not_stop_at_blanks_when_looking_backward_and_return_from_the_start_of_the_text_to_the_beginning_of_the_next_sentence_including_the_blanks_before_it() {
        let text = "dumb   and.     dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 8)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 0)
        XCTAssertEqual(aSentenceRange.count, 16) 
    }
    
    func test_that_for_the_last_sentence_of_the_text_it_returns_from_the_end_of_the_previous_sentence_including_the_blanks_after_it_to_the_end_of_the_text() {
        let text = "dumb   and.     dumber"
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 11)
        XCTAssertEqual(aSentenceRange.count, 11) 
    }
    
    // TODO: update func names with "trailing spaces" and "leading spaces"?
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_until_the_beginning_of_the_next_sentence_including_the_blanks_before_it() {
        let text = "dumb. and. dumber."
        
        let aSentenceRange = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(aSentenceRange.lowerBound, 6)
        XCTAssertEqual(aSentenceRange.count, 5) 
    }
    
}
