//
// MIT License
//
// Copyright (c) 2017-2020 MessageKit
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Danger

let danger = Danger()

//# This runs on CI
//mergeable_state = github.pr_json["mergeable_state"]
//
//# Make it more obvious that a PR a draft
//if mergeable_state == "draft"
//    warn("PR is marked as Draft")
//end

// Mainly to encourage writing up some reasoning about the PR, rather than just leaving a title
if (danger.github.pullRequest.body?.count ?? "") < 5 {
    fail("Please provide a summary in the Pull Request description")
}

let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles
let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
let isTrivial = (danger.github != nil) && danger.github.pullRequest.title.contains("#trivial")

if !isTrivial, !changelogChanged {
    fail("Please include a CHANGELOG entry. \nYou can find it at [CHANGELOG.md](https://github.com/MessageKit/MessageKit/blob/master/CHANGELOG.md).")
}

// Warn when there is a big PR
if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 1000 {
    warn("Big Pull Request - Please consider splitting up your changes into smaller Pull Requests.")
}

SwiftLint.lint(.modifiedAndCreatedFiles(directory: "Sources"), inline: true)

//swiftlint.config_file = '.swiftlint.yml'
//swiftlint.binary_path = 'Example/Pods/SwiftLint/swiftlint'
//swiftlint.lint_files inline_mode:true, fail_on_error:true
