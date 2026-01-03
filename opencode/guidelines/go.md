# Go Guidelines (Effective Go + idiomatic Go)

Summary from Effective Go (abridged):
- Use `gofmt` (tabs for indentation, standard formatting).
- Keep names short and clear; export with capitalization; avoid `Get` prefixes.
- Prefer small, focused interfaces (often 1-2 methods, `-er` names).
- Keep happy path left-aligned; avoid unnecessary `else` after `return`.
- Return and wrap errors with context; never ignore errors.
- Use `defer` for cleanup close to acquisition.
- Prefer useful zero values; avoid overly complex constructors.

Focus on:
- Idiomatic naming, small interfaces, and clear package boundaries.
- Error handling: wrap with context, avoid ignoring errors.
- Context propagation: pass context through call chains.
- Concurrency safety: avoid goroutine leaks, races, and deadlocks.
- Use `gofmt` formatting and standard import grouping.
- Avoid unnecessary abstractions and premature optimizations.

Always flag:
- Goroutine leaks (no cancellation, runaway loops).
- Resource leaks (missing `defer` close/cleanup).
- Data races or unsafe shared state.
- Dropped context or ignored errors in critical paths.

Examples (always flag):

- Goroutine leak (no cancellation):

```go
// Bad: goroutine never stops
go func() {
    for {
        doWork()
    }
}()
```

- Resource leak (missing close):

```go
f, err := os.Open(path)
if err != nil {
    return err
}
// Bad: no defer f.Close()
_, err = io.ReadAll(f)
```

- Data race (unsynchronized access):

```go
var count int

go func() { count++ }()
go func() { count++ }()
```

- Ignored error:

```go
// Bad: error ignored
_, _ = io.Copy(dst, src)
```

Examples:

- Error wrapping with context:

```go
if err != nil {
    return fmt.Errorf("read config: %w", err)
}
```

- Context propagation:

```go
func Fetch(ctx context.Context, id string) error {
    return svc.Get(ctx, id)
}
```
