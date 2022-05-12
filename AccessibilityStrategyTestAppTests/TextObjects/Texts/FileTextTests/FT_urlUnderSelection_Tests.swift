@testable import AccessibilityStrategy
import XCTest


// for VM `gx`. checks that the selected text is a valid URL and returns it if ok
class FT_urlUnderSelection_Tests: XCTestCase {}


extension FT_urlUnderSelection_Tests {

    func test_that_if_the_selection_is_not_a_link_it_returns_nil() {
        let text = "there is absolutely no link here"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let url = fileText.urlUnderSelection(range: 2..<7)
        
        XCTAssertNil(url)
    }
    
    func test_that_if_the_selection_is_a_link_it_returns_that_URL() {
        let text = "now we have https://kindavim.app here!"
        
        let fileText = FileText(end: text.utf16.count, value: text)
        let url = fileText.urlUnderSelection(range: 12..<32)
            
        XCTAssertEqual(url?.absoluteString, "https://kindavim.app")
    }
    
}
