# SimpleBudget

A minimalist app to track where your 💸 goes.

## Getting started

1. `carthage bootstrap --platform iOS`
1. Hack away

## Workflows and Guidelines

1. Follow branch-based [Github Workflow](https://guides.github.com/introduction/flow/)
1. Code must be formatted with [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) before submission.

_This `pre-commit` hook could be used._
```bash
#!/bin/bash
git diff --diff-filter=d --staged --name-only | grep -e '\(.*\).swift$' | while read line; do
  swiftformat "${line}" --config ".swiftformat";
  git add "$line";
done
```
