@testable import AccessibilityStrategy
import XCTest


// yes, `innerParagraph` cannot be from `beginningOfParagraph` to `endOfParagraph`.
// this is because in normal setting a blank line is not a paragraph boundary, but for
// innerParagraph it is. so it needs its own computation.
class FT_innerParagraph_Tests: XCTestCase {}


// Both
extension FT_innerParagraph_Tests {
    
    func test_that_if_the_text_is_empty_it_returns_a_range_of_0_to_0() {
        let text = ""
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 0)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 0)
    }
    
    func test_that_if_there_is_no_blank_or_empty_line_before_and_after_the_caretLocation_then_the_innerParagraph_is_the_whole_content() {
        let text = "so for innerParagraph blank lines are a boundary. it's an exception."
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 68) 
    }

}


// TextViews
extension FT_innerParagraph_Tests {
    
    func test_that_if_there_is_an_empty_line_before_the_caretLocation_but_none_after_then_the_innerParagraph_is_from_the_empty_line_to_the_end() {
        let text = """
hehe

well done
my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 6)
        XCTAssertEqual(innerParagraphRange.count, 19) 
    }
    
    func test_that_if_there_is_an_empty_line_after_the_caretLocation_but_non_before_then_the_innerParagraph_is_from_the_beginning_to_the_empty_line() {
        let text = """
hehe
well done

my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 14) 
    }
        
    // this test contains blank lines
    func test_that_if_there_is_a_blank_line_before_the_caretLocation_but_none_after_then_the_innerParagraph_is_from_the_empty_line_to_the_end() {
        let text = """
hehe
    
well done
my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 13)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 10)
        XCTAssertEqual(innerParagraphRange.count, 19) 
    }
    
    // this test contains blank lines
    func test_that_if_there_is_a_blank_line_after_the_caretLocation_but_non_before_then_the_innerParagraph_is_from_the_beginning_to_the_empty_line() {
        let text = """
hehe
well done
     
my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 10)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 0)
        XCTAssertEqual(innerParagraphRange.count, 14) 
    }
    
    func test_that_it_works_also_on_a_paragraph_made_of_empty_lines() {
        let text = """
hehe
well done





my friend
"""
        let fileText = FileText(end: text.utf16.count, value: text)
        let innerParagraphRange = fileText.innerParagraph(startingAt: 18)
        
        XCTAssertEqual(innerParagraphRange.lowerBound, 14)
        XCTAssertEqual(innerParagraphRange.count, 4) 
    }
    
}
