@testable import AccessibilityStrategy
import XCTest

class ASNM_BaseTests: XCTestCase {
    
    var textEngine = TextEngine()
    var asNormalMode: AccessibilityStrategyNormalMode!
    
    
    override func setUp() {
        super.setUp()
                       
        asNormalMode = AccessibilityStrategyNormalMode()
//        KindaVimEngine.shared.enterNormalMode()
    }    
    
}
