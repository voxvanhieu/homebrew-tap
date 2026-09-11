# I'm making some cold brew here. Would you like one?

## How do I install these formulae?

`brew install voxvanhieu/tap/<formula>`

Or `brew tap voxvanhieu/tap` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "voxvanhieu/tap"
brew "<formula>"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Release publication

Stable code-a-cv releases open formula PRs in this tap. After `brew test-bot`
passes, `brew pr-pull` automatically publishes bottles and pushes the formula
to `main`. Automatic publication accepts only same-repository PRs authored by
`voxvanhieu`, on a `code-a-cv-X.Y.Z` branch, changing only
`Formula/code-a-cv.rb`. The tested head SHA must still match the PR.

Other PRs retain the manual `brew pr-pull` workflow. Do not manually merge a
formula PR when bottles should be published. To check the automatic selection
logic locally, run `ruby scripts/tests/test_publish.rb`.
