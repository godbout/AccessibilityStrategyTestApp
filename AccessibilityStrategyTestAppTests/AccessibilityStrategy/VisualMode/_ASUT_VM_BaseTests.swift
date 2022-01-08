@testable import AccessibilityStrategy
import XCTest

class ASVM_BaseTests: XCTestCase {
    
    let asVisualMode = AccessibilityStrategyVisualMode()
    
    func copyToClipboard(text: String) {
        return asVisualMode.copyToClipboard(text: text)
    }
    
}
