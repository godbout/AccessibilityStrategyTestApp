@testable import AccessibilityStrategy
import XCTest


// see innerWord for blah blah
class FT_innerWORD__Tests_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Range<Int> {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.innerWORD(startingAt: caretLocation)
    }
    
}


// TextFields and TextViews
extension FT_innerWORD__Tests_Tests {
    
    func test_that_if_the_text_is_empty_it_returns_a_range_of_0_to_0() {
        let text = ""
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertEqual(WORDRange.lowerBound, 0)
        XCTAssertEqual(WORDRange.count, 0)
    }
    
    func test_that_if_the_caret_is_on_a_letter_if_finds_the_correct_innerWORD() {
        let text = "ok we're gonna-try to get the inner word here"
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 10)

        XCTAssertEqual(WORDRange.lowerBound, 9)
        XCTAssertEqual(WORDRange.count, 9)
    }
    
    func test_that_if_the_caret_is_on_a_space_the_innerWORD_is_all_the_consecutive_spaces() {
        let text = "ok so now we have a lot of     --spaces"
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 28)

        XCTAssertEqual(WORDRange.lowerBound, 26)
        XCTAssertEqual(WORDRange.count, 5)
    }
    
    func test_that_if_the_caret_is_on_a_single_space_it_recognizes_it_as_an_innerWORD() {
        let text = "a single space is an-- ^^inner word"
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 22)

        XCTAssertEqual(WORDRange.lowerBound, 22)
        XCTAssertEqual(WORDRange.count, 1)
    }
    
    func test_that_if_the_TextField_starts_with_spaces_it_finds_the_correct_innerWORD() {
        let text = "     **that's lots of spaces"
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 4)

        XCTAssertEqual(WORDRange.lowerBound, 0)
        XCTAssertEqual(WORDRange.count, 5)
    }
    
    func test_that_if_the_TextField_ends_with_spaces_it_still_gets_the_correct_innerWORD() {
        let text = "that's lots of spaces again**       "
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 31)

        XCTAssertEqual(WORDRange.lowerBound, 29)
        XCTAssertEqual(WORDRange.count, 7)
    }
    
    func test_that_if_the_text_is_a_single_character_it_grabs_from_the_beginning_to_the_end_of_the_word() {
        let text = "a"

        let WORDRange = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertEqual(WORDRange.lowerBound, 0)
        XCTAssertEqual(WORDRange.count, 1)
    }
       
    func test_that_if_the_text_starts_with_a_single_character_and_the_caretLocation_is_on_this_character_then_it_finds_the_correct_innerWORD() {
        let text = "a word"

        let WORDRange = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertEqual(WORDRange.lowerBound, 0)
        XCTAssertEqual(WORDRange.count, 1)
    }
        
    func test_that_if_the_last_word_of_a_text_is_a_single_character_it_grabs_the_correct_innerWORD() {
        let text = "a-"

        let WORDRange = applyFuncBeingTested(on: text, startingAt: 0)

        XCTAssertEqual(WORDRange.lowerBound, 0)
        XCTAssertEqual(WORDRange.count, 2)
    }

}


// TextViews
extension FT_innerWORD__Tests_Tests {
    
    func test_that_innerWORD_stops_at_linefeeds_at_the_end_of_lines() {
        let text = """
this shouldn't
spill      
   on the next line--
"""
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 23)

        XCTAssertEqual(WORDRange.lowerBound, 20)
        XCTAssertEqual(WORDRange.count, 6)
    }
    
    func test_that_innerWORD_stops_at_linefeeds_at_the_beginning_of_lines() {
        let text = """
this shouldn't
spill also    
    backwards
"""
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 33)

        XCTAssertEqual(WORDRange.lowerBound, 30)
        XCTAssertEqual(WORDRange.count, 4)
    }
    
    func test_that_innerWORD_stops_at_Linefeeds_both_at_beginning_and_end_of_lines_that_is_on_EmptyLines() {
        let text = """
this shouldn't

    backwards
"""
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 15)

        XCTAssertEqual(WORDRange.lowerBound, 15)
        XCTAssertEqual(WORDRange.count, 0)
    }
    
}


// emojis
// emojis are symbols so as long as we take care of the emojis length, all the rest
// works exactly like symbols: passing, skipping, part or not of words, etc...
// so no need to test those parts again.
extension FT_innerWORD__Tests_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️*** are longer than 1 length"
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 27)

        XCTAssertEqual(WORDRange.lowerBound, 24)
        XCTAssertEqual(WORDRange.count, 12)
    }
    
    func test_that_it_does_not_do_shit_with_emojis_before_a_space() {
        let text = "emojis are symbols that ***🔫️🔫️🔫️ are longer than 1 length"
        
        let WORDRange = applyFuncBeingTested(on: text, startingAt: 36)

        XCTAssertEqual(WORDRange.lowerBound, 36)
        XCTAssertEqual(WORDRange.count, 1)
    }
    
}
