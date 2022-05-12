@testable import AccessibilityStrategy
import XCTest


// at first this logic was within the `gx` move but it happens that sometimes
// a URL is deemed valid but NSWorkspace.shared.open() cannot open it because it's
// actually not really valid LOL. so we need to separate both logics. the validity
// of a URL is handled by a func on FileText. the result of opening that URL is done
// within the `gx` move.
class FT_urlUnderCaret_Tests: XCTestCase {}


// basic cases
extension FT_urlUnderCaret_Tests {
    
    func test_that_if_there_is_no_link_it_returns_nil() {
        let text = "there is absolutely no link here"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let url = fileText.urlUnderCaret(at: 4)
        
        XCTAssertNil(url)
    }
    
    func test_that_if_the_fileText_is_just_a_link_it_returns_that_URL() {
        let text = "https://kindavim.app"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let url = fileText.urlUnderCaret(at: 4)
            
        XCTAssertEqual(url?.absoluteString, "https://kindavim.app")
    }
    
    func test_that_if_gets_the_URL_in_the_middle_of_some_text() {
        let text = "ok so now we're doing https://kindavim.app some other shit"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let url = fileText.urlUnderCaret(at: 34)
            
        XCTAssertEqual(url?.absoluteString, "https://kindavim.app")
    }
    
    func test_that_it_gets_any_type_of_URL_like_macOS_files() {
        let text = "the path is file:///Users/guill yep"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let url = fileText.urlUnderCaret(at: 15)
            
        XCTAssertEqual(url?.absoluteString, "file:///Users/guill")
    }
    
}


// more special cases
extension FT_urlUnderCaret_Tests {
    
    func test_that_a_web_URL_written_in_Markdown_format_is_grabbed_correctly() {
        let text = "markdown [link](https://this-is-the-link-url) here we go"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let url = fileText.urlUnderCaret(at: 20)
            
        XCTAssertEqual(url?.absoluteString, "https://this-is-the-link-url")
    }

}
