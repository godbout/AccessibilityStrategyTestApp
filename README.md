<h1 align="center">AccessibilityStrategyTestApp<br>testing AccessibilityStrategy for <a href="https://github.com/godbout/kindaVim.theapp">kindaVim<a></h1>

<p align="center">
    <a href="https://github.com/godbout/AccessibilityStrategyTestApp/actions">
        <img src="https://github.com/godbout/AccessibilityStrategyTestApp/actions/workflows/main.yml/badge.svg"/>
    </a>
    <a href="https://codecov.io/gh/godbout/AccessibilityStrategyTestApp">
        <img src="https://codecov.io/gh/godbout/AccessibilityStrategyTestApp/branch/master/graph/badge.svg?token=IJOPnX05Fi"/>
    </a>
</p>

![AccessibilityStrategyTestApp ruining my computer](https://raw.githubusercontent.com/godbout/AccessibilityStrategyTestApp/media/gif.gif "hehe")

# WOT IS DAT

those are all the Unit and UI Tests related to the AccessibilityStrategy part of [kindaVim](https://github.com/godbout/kindaVim.theapp). i.e. the part where we can read and write text through the [macOS Accessibility](https://developer.apple.com/accessibility/macos/). not the fallback mode, key mapping, restricted mode, or kindaVim engine core.

the implementation is not available (hopefully...) but the tests may be helpful to you if you're developing some kind of Vim moves related project. Vim moves are complex, with lots of exceptions and edge cases. it's hard to get them correct. good luck.

# CI BUILD AND TESTS FAILING

the AccessibilityStrategy now requires macOS 12 minimum. GitHub Actions only goes up to 11 (haha). so back to running locally for now.
