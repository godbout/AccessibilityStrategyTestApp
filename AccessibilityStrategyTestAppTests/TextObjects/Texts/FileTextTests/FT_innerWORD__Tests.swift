@testable import AccessibilityStrategy
import XCTest


// see innerWord for blah blah
class FT_innerWORD__Tests_Tests: XCTestCase {}


// Both
extension FT_innerWORD__Tests_Tests {
    
    func test_that_if_the_text_is_empty_it_returns_a_range_of_0_to_0() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 0)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.count, 0)
    }
    
    func test_that_if_the_caret_is_on_a_letter_if_finds_the_correct_inner_word() {
        let text = "ok we're gonna-try to get the inner word here"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 10)
        
        XCTAssertEqual(wordRange.lowerBound, 9)
        XCTAssertEqual(wordRange.count, 9) 
    }
    
    func test_that_if_the_caret_is_on_a_space_the_inner_word_is_all_the_consecutive_spaces() {
        let text = "ok so now we have a lot of     --spaces"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 28)
        
        XCTAssertEqual(wordRange.lowerBound, 26)
        XCTAssertEqual(wordRange.count, 5)         
    }
    
    func test_that_if_the_caret_is_on_a_single_space_it_recognizes_it_as_an_inner_word() {
        let text = "a single space is an-- ^^inner word"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 22)
        
        XCTAssertEqual(wordRange.lowerBound, 22)
        XCTAssertEqual(wordRange.count, 1) 
    }
    
    func test_that_if_the_TextField_starts_with_spaces_it_finds_the_correct_inner_word() {
        let text = "     **that's lots of spaces"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 4)
        
        XCTAssertEqual(wordRange.lowerBound, 0)
        XCTAssertEqual(wordRange.count, 5) 
    }
    
    func test_that_if_the_TextField_ends_with_spaces_it_still_gets_the_correct_inner_word() {
        let text = "that's lots of spaces again**       "
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 31)
        
        XCTAssertEqual(wordRange.lowerBound, 29)
        XCTAssertEqual(wordRange.count, 7) 
    }

}


// TextViews
extension FT_innerWORD__Tests_Tests {
    
    func test_that_inner_word_stops_at_linefeeds_at_the_end_of_lines() {
        let text = """
this shouldn't
spill      
   on the next line--
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 23)
        
        XCTAssertEqual(wordRange.lowerBound, 20)
        XCTAssertEqual(wordRange.count, 6)
    }
    
    func test_that_inner_word_stops_at_linefeeds_at_the_beginning_of_lines() {
        let text = """
this shouldn't
spill also    
    backwards
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 33)
        
        XCTAssertEqual(wordRange.lowerBound, 30)
        XCTAssertEqual(wordRange.count, 4)
    }
    
    func test_that_innerWord_stops_at_Linefeeds_both_at_beginning_and_end_of_lines_that_is_on_empty_lines() {
        let text = """
this shouldn't

    backwards
"""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordrange = fileText.innerWord(startingAt: 15)
        
        XCTAssertEqual(wordrange.lowerBound, 15)
        XCTAssertEqual(wordrange.count, 0)
    }
    
}


// emojis
// emojis are symbols so as long as we take care of the emojis length, all the rest
// works exactly like symbols: passing, skipping, part or not of words, etc...
// so no need to test those parts again.
extension FT_innerWORD__Tests_Tests {
    
    func test_that_it_handles_emojis() {
        let text = "emojis are symbols that 🔫️🔫️🔫️*** are longer than 1 length"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 27)
        
        XCTAssertEqual(wordRange.lowerBound, 24)
        XCTAssertEqual(wordRange.count, 12)                
    }
    
    func test_that_it_does_not_do_shit_with_emojis_before_a_space() {
        let text = "emojis are symbols that ***🔫️🔫️🔫️ are longer than 1 length"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let wordRange = fileText.innerWORD(startingAt: 36)
        
        XCTAssertEqual(wordRange.lowerBound, 36)
        XCTAssertEqual(wordRange.count, 1)                
    }
    
}
