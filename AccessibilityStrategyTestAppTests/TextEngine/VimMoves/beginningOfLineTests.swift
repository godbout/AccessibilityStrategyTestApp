@testable import AccessibilityStrategy
import XCTest


// there's not test for emojis but there's no need in here, in opposition of
// endOfLine. endOfLine needs because it may end up at the end of text and we
// need to calculate the previous position. but for beginningOfLine we don't need.
// we need to always add the linefeed character length, so no need for emojis.
class beginningOfLineTests: TextEngineBaseTests {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension beginningOfLineTests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let beginningOfLineLocation = textEngine.beginningOfLine(startingAt: 0, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfLineLocation, 0)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_returns_the_length_of_the_text() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        let beginningOfLineLocation = textEngine.beginningOfLine(startingAt: 54, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfLineLocation, 54)
    }
    
}


// Both
extension beginningOfLineTests {
    
    func test_that_it_finds_the_beginning_of_a_line_that_does_not_have_a_linefeed_preceding_it() {
        let text = "this line does not have a linefeed before it but we should still be able to go at the beginning!"

        let beginningOfLineLocation = textEngine.beginningOfLine(startingAt: 43, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfLineLocation, 0)
    }
    
    func test_that_it_finds_the_beginning_of_a_line_that_does_have_a_linefeed_preceding_it() {
        let text = """
the first line will
not have a linefeed
but we're gonna check the last
"""
        let beginningOfLineLocation = textEngine.beginningOfLine(startingAt: 51, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfLineLocation, 40)
    }
    
    func test_that_if_the_caret_is_already_at_the_beginning_of_a_line_it_does_not_move() {
        let text = """
let's put the caret
already at the beginning
of the line
"""
        let beginningOfLineLocation = textEngine.beginningOfLine(startingAt: 20, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfLineLocation, 20)
    }
        
    func test_that_if_the_caret_is_on_an_empty_line_it_does_not_move() {
        let text = """
obviously this test is here
because

of a bug :D
"""
        
        let beginningOfLineLocation = textEngine.beginningOfLine(startingAt: 36, in: TextEngineText(from: text))
        
        XCTAssertEqual(beginningOfLineLocation, 36)
    }
    
}
