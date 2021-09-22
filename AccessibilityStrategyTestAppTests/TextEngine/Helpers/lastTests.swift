@testable import AccessibilityStrategy
import XCTest


class lastTests: TextEngineBaseTests {}

// Both
extension lastTests {
    
    func test_that_in_normal_setting_it_returns_the_correct_location() {
        let text = "we should get the location of the last character found!"
        
        let location = textEngine.last("f", in: text)
        
        XCTAssertEqual(location, 49)
    }
    
    func test_that_if_it_cannot_find_the_character_it_returns_nil() {
        let text = "can't find the character hehe"
        
        let location = textEngine.last("z", in: text)
        
        XCTAssertEqual(location, nil)
    }
    
    func test_that_it_returns_nil_for_an_empty_line() {
        let text = ""
        
        let location = textEngine.last("b", in: text)
        
        XCTAssertEqual(location, nil)
    }

}


// TextViews
extension lastTests {
    
    func test_that_in_multiline_texts_it_returns_the_last_of_the_whole_text() {
        let text = """
a big text
that is big
yes big
"""
        let location = textEngine.last("g", in: text)
        
        XCTAssertEqual(location, 29)
    }
    
}
