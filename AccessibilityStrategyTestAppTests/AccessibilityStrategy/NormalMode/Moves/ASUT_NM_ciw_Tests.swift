@testable import AccessibilityStrategy
import XCTest


// ciw uses TE.innerWord. this is already fully tested.
// contrary to TE.aWord, innerWord never returns nil because Vim always finds an innerWord.
// because of PGR the few tests to do here have been moved to UI Tests.
class ASUT_NM_ciw_Tests: ASNM_BaseTests {}
