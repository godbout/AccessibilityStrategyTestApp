import XCTest
import AccessibilityStrategy


class ASUI_NM_BaseTests: XCTestCase {

    var app: XCUIApplication!
    
    let accessibilityStrategy = AccessibilityStrategy()
    let asNormalMode = AccessibilityStrategyNormalMode()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }
    
    
    func applyMoveAndGetBackAccessibilityElement(_ move: (AccessibilityTextElement?) -> AccessibilityTextElement?) -> AccessibilityTextElement? {
        let currentElement = accessibilityStrategy.focusedTextElement()
        guard let elementAfterMove = move(currentElement) else { return nil }
        _ = accessibilityStrategy.push(element: elementAfterMove)
        let updatedElementAfterPush = accessibilityStrategy.focusedTextElement()

        return updatedElementAfterPush
    }
        
    func applyMoveAndGetBackAccessibilityElement(character: Character, _ move: (Character, AccessibilityTextElement?) -> AccessibilityTextElement?) -> AccessibilityTextElement? {
        let currentElement = accessibilityStrategy.focusedTextElement()
        guard let elementAfterMove = move(character, currentElement) else { return nil }
        _ = accessibilityStrategy.push(element: elementAfterMove)
        let updatedElementAfterPush = accessibilityStrategy.focusedTextElement()

        return updatedElementAfterPush
    }

}

