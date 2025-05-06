# @prettier/plugin-ruby and rubocop incompatibility example

See this sample code in app.rb

```ruby
expect do
  foo
end.to change(Bar, :baz, 1)
```

rubocop is happy with this code:

```
$ bundle exec rubocop
Inspecting 2 files
..

2 files inspected, no offenses detected
```

However, prettier is not:

```
$ node_modules/.bin/prettier --check .
Checking formatting...
[warn] app.rb
[warn] Code style issues found in the above file. Run Prettier with --write to fix.
```

When I format it with prettier (`node_modules/.bin/prettier --write .`), the code changes to:

```ruby
expect do foo end.to change(Bar, :baz, 1)
```

Now prettier is happy:

```
$ node_modules/.bin/prettier --check .
Checking formatting...
All matched files use Prettier code style!
```

But rubocop is not:

```
$ bundle exec rubocop
Inspecting 2 files
.C

Offenses:

app.rb:1:1: C: [Correctable] Style/SingleLineDoEndBlock: Prefer multiline do...end block.
expect do foo end.to change(Bar, :baz, 1)
^^^^^^^^^^^^^^^^^
app.rb:1:8: C: [Correctable] Style/BlockDelimiters: Prefer {...} over do...end for single-line blocks.
expect do foo end.to change(Bar, :baz, 1)
       ^^

2 files inspected, 2 offenses detected, 2 offenses autocorrectable
```

But... if I correct those rubocop issues, I end up with the code I started with, and prettier is unhappy again. I'm in an **infinite loop**. The tools are clashing with each other.

If I instead write the code like this, both tools are happy

```ruby
expect { foo }.to change(Bar, :baz, 1)
```

If prettier were to autoformat the original code into _this_ code, both tools would be happy. I can do it manually in the meantime but it would be cool if it Just Worked automatically.
