@testable import AccessibilityStrategy
import XCTest


// TODO: might be that we wanna do innerSentence first coz maybe aSentence will be based on that?
class FT_innerSentence_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerSentence(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_innerSentence_NormalSetting_Tests {

    func test_that_if_the_text_is_just_one_word_then_it_returns_the_whole_text_lol() {
        let text = "dumb"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 4) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blank() {
        let text = "dumb. and dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 5) 
    }
    
    func test_that_for_the_first_sentence_of_the_text_it_returns_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "dumb.                      and dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 3)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 5) 
    }
        
    func test_that_for_the_first_sentence_of_the_text_it_does_not_stop_at_blanks_when_looking_backward_and_return_from_the_start_of_the_text_to_the_end_of_the_first_sentence_not_including_the_trailing_blanks() {
        let text = "dumb   and.     dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 8)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 0)
        XCTAssertEqual(innerSentenceRange.count, 11) 
    }
    
    func test_that_for_the_last_sentence_of_the_text_it_returns_from_the_beginning_of_the_last_sentence_not_including_the_leading_blanks_to_the_end_of_the_text() {
        let text = "dumb   and.     dumber"
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 18)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 16)
        XCTAssertEqual(innerSentenceRange.count, 6) 
    }
    
    func test_that_if_a_sentence_is_surrounded_by_two_other_sentences_then_it_returns_from_the_beginning_of_that_sentence_not_including_the_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb. and. dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 6)
        XCTAssertEqual(innerSentenceRange.count, 4) 
    }
    
    func test_that_if_the_caret_is_on_a_blank_that_is_before_a_sentence_it_just_returns_the_leading_blanks_of_that_sentence_lol() {
        let text = "dumb.        and.      dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 9)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 5)
        XCTAssertEqual(innerSentenceRange.count, 8) 
    }
        
    // TODO: failing
    // should we split the "on a blank"?
    func test_that_if_the_caret_is_on_a_blank_within_a_sentence_it_returns_from_the_beginning_of_that_sentence_not_including_leading_blanks_to_the_end_of_that_sentence_not_including_the_trailing_blanks() {
        let text = "dumb.        and  and.      dumber."
        
        let innerSentenceRange = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(innerSentenceRange.lowerBound, 13)
        XCTAssertEqual(innerSentenceRange.count, 9) 
    }
    
}
