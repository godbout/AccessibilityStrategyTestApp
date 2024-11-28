@testable import AccessibilityStrategy
import XCTest


// see nextNonBlank for blah blah
class FL_previousNonBlank_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) throws -> Int? {
        let fileLine = try XCTUnwrap(
            FileLine(fullFileText: text, fullFileTextLength: text.utf16.count, caretLocation: caretLocation)
        )
                
        return fileLine.previousNonBlank(startingAt: caretLocation)
    }
    
}
    

// Both
extension FL_previousNonBlank_Tests {

    func test_that_it_returns_nil_if_the_text_is_empty() {
        let text = ""
        
        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertNil(previousNonBlankLocation)
    }
    
    func test_that_it_gets_the_correct_location_for_a_nonBlank_preceded_by_another_nonBlank() {
        let text = "so that's gonna be a normal case ok?"
        
        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 12)
        
        XCTAssertEqual(previousNonBlankLocation, 11)
    }
    
    func test_that_it_gets_the_correct_location_for_a_nonBlank_preceded_by_a_blank() {
        let text = "ok so now we're gonna be preceded by a blank LOL"
        
        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 25)
        
        XCTAssertEqual(previousNonBlankLocation, 23)
    }
    
    func test_that_it_gets_the_correct_location_for_a_nonBlank_preceded_by_several_blanks() {
        let text = "now we're gonna have                 many blanks"
        
        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 37)
        
        XCTAssertEqual(previousNonBlankLocation, 19)
    }
    
    func test_that_it_gets_the_correct_location_for_a_blank_preceded_by_a_nonBlank() {
        let text = "a     blank preceded by a non blank"
        
        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 11)
        
        XCTAssertEqual(previousNonBlankLocation, 10)
    }
    
    func test_that_it_gets_the_correct_location_for_a_blank_preceded_by_another_blank() {
        let text = "a     blank preceded by  a non blank"
        
        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 24)
        
        XCTAssertEqual(previousNonBlankLocation, 22)
    }
    
    func test_that_it_gets_the_correct_location_for_a_blank_preceded_by_several_blanks() {
        let text = "a     blank preceded by            a non blank"
        
        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 29)
       
        XCTAssertEqual(previousNonBlankLocation, 22)
    }
       
    func test_that_it_returns_nil_if_there_is_no_previous_nonBlank_which_would_mean_from_the_caret_to_the_beginning_of_the_FileLine_it_is_all_blanks() {
        let text = "                    this time no non blank"
        
        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 16)
       
        XCTAssertNil(previousNonBlankLocation)
    }
    
}


// TextViews
extension FL_previousNonBlank_Tests {
    
    func test_that_it_gets_the_correct_location_if_the_location_is_not_on_the_first_FileLine() {
        let text = """
doing this one because we need to calculate
the relative caretLocation of FLs
else it's crashing of course!
"""

        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 57)
       
        XCTAssertEqual(previousNonBlankLocation, 55)
    }
    
    // this test contains blanks
    func test_that_if_it_reaches_the_beginning_of_a_line_it_returns_nil_because_we_are_testing_on_FileLines() {
        let text = """
linefeed are not      
     considered blanks
"""

        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 26)
       
        XCTAssertNil(previousNonBlankLocation)
    }
    
}


// emojis
// see beginningOfWordBackward for the blah blah
extension FL_previousNonBlank_Tests {
    
    func test_that_it_handles_emojis() throws {
        let text = "honestly are emojis 😂️     working"

        let previousNonBlankLocation = try? applyFuncBeingTested(on: text, startingAt: 26)
       
        XCTAssertEqual(previousNonBlankLocation, 20)
    }
    
}
