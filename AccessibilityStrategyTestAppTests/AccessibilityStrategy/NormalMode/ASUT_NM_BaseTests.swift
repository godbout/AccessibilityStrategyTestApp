@testable import AccessibilityStrategy
import XCTest

// TODO: rename ASNM to ASUT
class ASNM_BaseTests: XCTestCase {
    
    let asNormalMode = AccessibilityStrategyNormalMode()
    
    func copyToClipboard(text: String) {
        return asNormalMode.copyToClipboard(text: text)
    }
    
}
