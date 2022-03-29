import XCTest
@testable import AccessibilityStrategy


// those tests are set apart from the others because they are specific to how the TextArea scrolling is set.
// complicated and sensitive, and not related to the other cases, so they have their own tests.
class FullyVisibleAreaTests: ATEA_BaseTests {
    
    func test_that_if_the_TextArea_is_not_filled_with_text_hence_there_is_not_scrolling_happening_then_the_fullVisibleArea_is_correct() {
        let textInAXFocusedElement = """
that's just gonna be some
        small test and it's
the fullyVisibleArea will be the whole
TextArea
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: .command)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 0..<101)
        XCTAssertEqual(accessibilityElement?.fullyVisibleAreaUpperBoundLimit, 101)
    }
    
    func test_that_if_the_TextArea_is_filled_with_text_and_it_is_scrolled_to_the_top_then_the_fullyVisibleArea_is_correct() {
        let textInAXFocusedElement = """
It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself “The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She’ll get me executed, as sure as ferrets are ferrets! Where can I have dropped them, I wonder?” Alice guessed in a moment that it was looking for the
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey(.upArrow, modifierFlags: .command)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 0..<241)
        XCTAssertEqual(accessibilityElement?.fullyVisibleAreaUpperBoundLimit, 240)
    }
    
    func test_that_if_the_TextArea_is_filled_with_text_and_it_is_scrolled_to_the_bottom_then_the_fullyVisibleArea_is_correct() {
        let textInAXFocusedElement = """
It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself “The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She’ll get me executed, as sure as ferrets are ferrets! Where can I have dropped them, I wonder?” Alice guessed in a moment that it was looking for the
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 136..<378)
        XCTAssertEqual(accessibilityElement?.fullyVisibleAreaUpperBoundLimit, 378)
    }
    
    func test_that_if_the_TextArea_is_filled_with_text_and_it_is_scrolled_to_the_bottom_and_the_text_ends_with_an_empty_line_then_the_fullyVisibleArea_is_correct() {
        let textInAXFocusedElement = """
It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself “The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She’ll get me executed, as sure as ferrets are ferrets! Where can I have dropped them, I wonder?” Alice guessed in a moment that it was looking for the

"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 159..<379)
        XCTAssertEqual(accessibilityElement?.fullyVisibleAreaUpperBoundLimit, 379)
    }

    func test_that_if_the_TextArea_is_filled_with_text_and_there_is_leeway_on_the_top_and_at_the_bottom_then_the_fullyVisibleArea_is_correct() {
        let textInAXFocusedElement = """
It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself “The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She’ll get me executed, as sure as ferrets are ferrets! Where can I have dropped them, I wonder?” Alice guessed in a moment that it was looking for the
It was the White Rabbit, trotting slowly back again, and looking anxiously about as it went, as if it had lost something; and she heard it muttering to itself “The Duchess! The Duchess! Oh my dear paws! Oh my fur and whiskers! She’ll get me executed, as sure as ferrets are ferrets! Where can I have dropped them, I wonder?” Alice guessed in a moment that it was looking for the
"""
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(textInAXFocusedElement)
        app.textViews.firstMatch.typeKey("a", modifierFlags: .control)
        
        let accessibilityElement = AccessibilityTextElementAdaptor.fromAXFocusedElement()
        
        XCTAssertEqual(accessibilityElement?.fullyVisibleArea, 262..<515)
        XCTAssertEqual(accessibilityElement?.fullyVisibleAreaUpperBoundLimit, 514)
    }

}
