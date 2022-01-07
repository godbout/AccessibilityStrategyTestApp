import XCTest
import AccessibilityStrategy


class ASUI_BaseTests: XCTestCase {
    
    var app: XCUIApplication!
    
    let accessibilityStrategy = AccessibilityStrategy()
    let asNormalMode = AccessibilityStrategyNormalMode()
    var asVisualMode: AccessibilityStrategyVisualMode!
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        
        // new one for every test coz anchor and head are static instance properties
        asVisualMode = AccessibilityStrategyVisualMode()
    }
    
    @discardableResult
    func applyMove(_ move: (_ element: AccessibilityTextElement) -> AccessibilityTextElement) -> AccessibilityTextElement {
        // TODO: currently forcing. not good. need to see how to break the tests properly
        // need to find a way to fail the tests gracefully
        let focusedElement = accessibilityStrategy.focusedTextElement()!
        let transformedElement = move(focusedElement)
        _ = accessibilityStrategy.push(element: transformedElement)
        let latestFocusedElement = accessibilityStrategy.focusedTextElement()!
        
        return latestFocusedElement
    }
    
    @discardableResult
    func applyMove(with character: Character, _ move: (Character, AccessibilityTextElement) -> AccessibilityTextElement) -> AccessibilityTextElement {
        let focusedElement = accessibilityStrategy.focusedTextElement()!
        let transformedElement = move(character, focusedElement)
        _ = accessibilityStrategy.push(element: transformedElement)
        let latestFocusedElement = accessibilityStrategy.focusedTextElement()! 

        return latestFocusedElement
    }

}
