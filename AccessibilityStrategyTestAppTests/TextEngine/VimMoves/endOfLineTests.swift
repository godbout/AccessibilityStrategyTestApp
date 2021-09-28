@testable import AccessibilityStrategy
import XCTest


// TODO: reminder—end of line is in Vim way. that means end limit. line endOfWord etc...
class endOfLineTests: TextEngineBaseTests {}


// The 3 Cases:
// - empty TextElement
// - 2nd case is now gone!
// - caret at the end of TextElement on own empty line
extension endOfLineTests {
    
    func test_that_if_the_text_is_empty_then_it_returns_0() {
        let text = ""
        
        let endOfLineLocation = textEngine.endOfLine(startingAt: 0, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfLineLocation, 0)
    }
    
    func test_that_if_the_caret_is_after_the_last_character_on_an_empty_line_then_it_returns_the_length_of_the_text() {
        let text = """
a couple of
lines but not
coke haha but
with linefeed

"""
        let endOfLineLocation = textEngine.endOfLine(startingAt: 54, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfLineLocation, 54)
    }
    
}


// Both
extension endOfLineTests {
    
    func test_that_it_finds_the_end_of_a_line_that_does_not_finish_with_a_linefeed_like_in_a_TextField_or_at_the_end_of_a_TextView() {
        let text = "this line does not end with a linefeed i swear"

        let endOfLineLocation = textEngine.endOfLine(startingAt: 4, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfLineLocation, 45)
    }
    
    func test_that_it_finds_the_end_of_a_line_that_finishes_with_a_linefeed() {
        let text = """
the last line will
not have a linefeed
but we're gonna check the first
"""
        let endOfLineLocation = textEngine.endOfLine(startingAt: 3, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfLineLocation, 17)
    }
    
    func test_that_if_the_caret_is_already_at_the_end_of_a_line_it_does_not_move() {
        let text = """
let's put the caret
already at the end
of the line
"""
        let endOfLineLocation = textEngine.endOfLine(startingAt: 37, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfLineLocation, 37)
    }
        
    func test_that_it_can_end_on_an_emoji() {
        let text = "kawai hehehe 💩️"
        
        let endOfLineLocation = textEngine.endOfLine(startingAt: 0, in: TextEngineText(from: text))
        
        XCTAssertEqual(endOfLineLocation, 13)
    }

}
