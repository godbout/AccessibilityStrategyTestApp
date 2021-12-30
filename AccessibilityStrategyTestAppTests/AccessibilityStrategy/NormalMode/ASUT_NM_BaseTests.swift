@testable import AccessibilityStrategy
import XCTest

class ASUT_NM_BaseTests: XCTestCase {
    
    let asNormalMode = AccessibilityStrategyNormalMode()
    
    func copyToClipboard(text: String) {
        return asNormalMode.copyToClipboard(text: text)
    }
    
}
