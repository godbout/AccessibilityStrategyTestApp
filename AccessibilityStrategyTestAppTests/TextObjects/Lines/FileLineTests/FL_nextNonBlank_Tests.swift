@testable import AccessibilityStrategy
import XCTest


// FL and FT nextNonBlank are the same actually coz they're implemented on the FO protocol
// but i find it easier to understand the separation, so i test the func on both FL and FT.
// also UT are cheap, so here you go!
// hint: Blanks are spaces and tabs. Newline is not Blank! (at least most of the time... in some moves it's considered Blank in Vim...)
class FL_nextNonBlank_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, after caretLocation: Int) throws -> Int? {
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: caretLocation)
        )
                
        return fileLine.nextNonBlank(after: caretLocation)
    }
    
}
    

// TextFields and TextViews
extension FL_nextNonBlank_Tests {

    func test_that_it_returns_nil_if_the_text_is_empty() {
        let text = ""
        
        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 0)
        
        XCTAssertNil(nextNonBlankLocation)
    }
    
    func test_that_it_gets_the_correct_location_for_a_nonBlank_followed_by_another_nonBlank() {
        let text = "so that's gonna be a normal case ok?"
        
        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 12)
        
        XCTAssertEqual(nextNonBlankLocation, 13)
    }
    
    func test_that_it_gets_the_correct_location_for_a_nonBlank_followed_by_a_Blank() {
        let text = "ok so now we're gonna be followed by a blank LOL"
        
        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 23)
        
        XCTAssertEqual(nextNonBlankLocation, 25)
    }
    
    func test_that_it_gets_the_correct_location_for_a_nonBlank_followed_by_several_Blanks() {
        let text = "now we're gonna have                 many blanks"
        
        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 19)
        
        XCTAssertEqual(nextNonBlankLocation, 37)
    }
    
    func test_that_it_gets_the_correct_location_for_a_Blank_followed_by_a_nonBlank() {
        let text = "a     blank followed by a non blank"
        
        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 5)
        
        XCTAssertEqual(nextNonBlankLocation, 6)
    }
    
    func test_that_it_gets_the_correct_location_for_a_Blank_followed_by_another_Blank() {
        let text = "a     blank followed by a non blank"
        
        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 4)
        
        XCTAssertEqual(nextNonBlankLocation, 6)
    }
    
    func test_that_it_gets_the_correct_location_for_a_Blank_followed_by_several_Blanks() {
        let text = "a     blank followed by a non blank"
        
        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 3)
       
        XCTAssertEqual(nextNonBlankLocation, 6)
    }
       
    func test_that_it_returns_nil_if_there_is_no_next_NonBlank_which_would_mean_we_are_at_the_end_of_the_text_and_it_does_not_end_with_a_Newline() {
        let text = "this time no non blank            "
        
        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 25)
       
        XCTAssertNil(nextNonBlankLocation)
    }
    
}


// TextViews
extension FL_nextNonBlank_Tests {
    
    func test_that_it_gets_the_correct_location_if_the_location_is_not_on_the_first_FileLine() {
        let text = """
doing this one because we need to calculate
the relative caretLocation of FLs
else it's crashing of course!
"""

        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 55)
       
        XCTAssertEqual(nextNonBlankLocation, 57)
    }
    
    // this test contains blanks
    func test_that_for_a_line_that_ends_with_a_Newline_it_returns_the_Newline() {
        let text = """
so the next non blank      
should not go to the next line
"""

        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 25)
       
        XCTAssertEqual(nextNonBlankLocation, 27)
    }
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_nextNonBlank_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = "honestly are emojis    😂️ working"

        let nextNonBlankLocation = try? applyFuncBeingTested(on: text, after: 20)
       
        XCTAssertEqual(nextNonBlankLocation, 23)
    }
    
}
