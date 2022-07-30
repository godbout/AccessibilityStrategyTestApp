@testable import AccessibilityStrategy
import XCTest


class FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests: XCTestCase {
    
    private func applyFuncBeingTested(on text: String, startingAt caretLocation: Int) -> Int {
        let fileText = FileText(end: text.utf16.count, value: text)
        
        return fileText.beginningOfSentenceBackward(startingAt: caretLocation)
    }
    
}


// TextViews
extension FT_beginningOfSentenceBackward_OnEmptyOrBlankLines_Tests {
    
    // TODO: this one
    // TODO: plus stuck when already at the beginning of sentence
    func test_that_paragraph_boundaries_are_also_sentence_boundaries() {
        let text = """
so it's not gonna skip lines but stop
at paragraph boundaries





can check the impl of that
"""
        let beginningOfSentenceForwardLocation = applyFuncBeingTested(on: text, startingAt: 84)
        
        XCTAssertEqual(beginningOfSentenceForwardLocation, 62)
    }
    
}
