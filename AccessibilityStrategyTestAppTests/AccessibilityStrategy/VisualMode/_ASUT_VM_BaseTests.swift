@testable import AccessibilityStrategy
import XCTest

class ASUT_VM_BaseTests: XCTestCase {
    
    let asVisualMode = AccessibilityStrategyVisualMode()
    
    func copyToClipboard(text: String) {
        return asVisualMode.copyToClipboard(text: text)
    }
    
}
