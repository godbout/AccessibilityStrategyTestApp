@testable import AccessibilityStrategy
import XCTest


// tests for when the caret is not on an empty or blank line
class FT_beginningOfSentenceForward_NormalSetting_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceForward(startingAt: caretLocation)
    }
    
}


// Both
extension FT_beginningOfSentenceForward_NormalSetting_Tests {

    func test_that_if_the_text_is_just_one_word_then_it_goes_to_the_endLimit_of_the_text() {
        let text = "dumb"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 3)
    }
    
    func test_that_it_detects_the_dot_as_an_end_of_sentence() {
        let text = "dumb. and dumber"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 0)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 6)
    }
    
    func test_that_it_skips_over_multiple_spaces() {
        let text = "dumb. and.                      dumber"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 32)
    }
    
    func test_that_it_detects_the_exclamation_mark_as_an_end_of_sentence() {
        let text = "dumb. and!    dumber"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 14)
    }
        
    func test_that_it_detects_the_interrogation_mark_as_an_end_of_sentence() {
        let text = "dumb. and dumber?  is that true"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 6)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 19)
    }
        
    func test_that_it_requires_at_least_one_space_after_the_delimiting_punctuation() {
        let text = "dumb.anddumber?is  that true"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 27)
    }
        
    func test_that_an_infinite_number_of_closing_parentheses_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's.))))   kinda crispy stuff"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 2)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 24)
    }
        
    func test_that_an_infinite_number_of_closing_brackets_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's!]]]]]]]]]]]]   kinda crispy stuff"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 32)
    }
    
    func test_that_a_closing_braces_are_NOT_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = "wow ok so that's!}}}}}}}}}}}}   kinda crispy stuff"
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 49)
    }
    
    func test_that_an_infinite_number_of_doubleQuotes_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = #"wow ok so that's?"""   kinda crispy stuff"#
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 23)
    }

    func test_that_an_infinite_number_of_singleQuotes_are_allowed_after_the_delimiting_punctuation_and_before_any_whitespace() {
        let text = #"wow ok so that's?''''''''   kinda crispy stuff"#
        
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 5)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 28)
    }
        
}


// TextViews
// surrounded by EmptyLines
extension FT_beginningOfSentenceForward_NormalSetting_Tests {

    func test_that_paragraph_boundaries_are_also_sentence_boundaries() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 10)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 62)
    }
    
}


// TextViews
// surrounded by Blank Lines
extension FT_beginningOfSentenceForward_NormalSetting_Tests {
    
    func test_that_it_skips_BlankLines() {
        let text = """
below is a blank line
          
 below is an empty line

   for example it
   it should go to the empty line
   no the lines above
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 17)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 57)
    }
    
    func test_that_it_skips_multiple_BlankLines() {
        let text = """
  it.    shoud
   
  
   
     
  go up. directly
""" 
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 7)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 41)
    }
    
}


// bug found
extension FT_beginningOfSentenceForward_NormalSetting_Tests {
    
    func test_that_it_stops_at_an_emptyLine_if_the_previous_sentence_has_a_dot_before_its_linefeed() {
        let text = """
here is a sentence that ends with a dot and a linefeed.

the line above is an empty line and ( should stop there
"""
        let _ = AccessibilityTextElement(
            role: .textArea,
            value: text,
            length: 112,
            caretLocation: 29,
            selectedLength: 1,
            selectedText: """
        w
        """,
            fullyVisibleArea: 0..<112,
            currentScreenLine: ScreenLine(
                fullTextValue: text,
                fullTextLength: 112,
                number: 1,
                start: 0,
                end: 56
            )!
        )
                
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 29)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 56)
    }

}
