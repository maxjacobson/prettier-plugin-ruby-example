expect do
  foo
end.to change(Bar, :baz, 1)
