# Go Guidelines (Effective Go + idiomatic Go)

**Style Guide Reference**: [Effective Go](https://go.dev/doc/effective_go)

**Naming Conventions**:
- **Packages**: Lowercase, single-word names without underscores. Short, concise, evocative. The package name becomes the accessor (`bytes.Buffer` not `bytes.ByteBuffer`).
- **Exported vs. Unexported**: Visibility by capitalization.
- **Functions/Methods**: Avoid redundancy with package names (`ring.New` not `ring.NewRing`). Getters: `Owner()` not `GetOwner()`. Setters: `SetOwner()`. Single-method interfaces use `-er` suffix: `Reader`, `Writer`, `Formatter`.
- **Multiword**: `MixedCaps` or `mixedCaps`, not underscores.

**Formatting**: Use `gofmt` (tabs). Control structures don't need parentheses around conditions.

**Code Structure**:
- Keep happy path left-aligned; avoid unnecessary `else` after `return`.
- Use `range` for iterating. Use blank identifier `_` to discard unwanted values.
- No automatic fall-through in switch.
- Return errors as additional values. Use `defer` for cleanup close to acquisition.
- Prefer useful zero values; avoid overly complex constructors.

**Error Handling**:
- Return and wrap errors with context; never ignore errors.
- Use "comma ok" idiom to distinguish missing entries from zero values.
- **Panic**: Only for unrecoverable errors or truly impossible situations.

**Concurrency**: "Do not communicate by sharing memory; instead, share memory by communicating."
- Use channels to synchronize goroutines.
- Use `select` with `default` for non-blocking operations.

**Interface Design**: Small interfaces (1-2 methods). Export interfaces rather than concrete types when types exist only to implement them. Use embedding to combine behaviors.

**Review Checklist** (Go-specific):
- Naming conventions (packages, variables, functions, abbreviations, prefer shorter names)
- Struct/interface design patterns
- Function complexity and indentation (happy path left-aligned)
- Unnecessary abstractions
- Parameter style (no named returns unless they improve clarity)
- Testing patterns (table tests)
- Prohibited patterns (global vars, init functions, panic)
- Context propagation: pass context through call chains

**Always Flag**:
- **Goroutine leaks**: No cancellation, runaway loops
- **Resource leaks**: Missing `defer` close/cleanup
- **Data races**: Unsynchronized access to shared variables
- **Error ignoring**: Using blank identifier to discard errors
- **Context misuse**: Ignoring context parameters or improper propagation

**Examples (always flag)**:

Goroutine leak (no cancellation):
```go
// Bad: goroutine never stops
go func() {
    for {
        doWork()
    }
}()
```

Resource leak (missing close):
```go
f, err := os.Open(path)
if err != nil {
    return err
}
// Bad: no defer f.Close()
_, err = io.ReadAll(f)
```

Data race (unsynchronized access):
```go
var count int

go func() { count++ }()
go func() { count++ }()
```

Ignored error:
```go
// Bad: error ignored
_, _ = io.Copy(dst, src)
```

Good patterns:

Error wrapping with context:
```go
if err != nil {
    return fmt.Errorf("read config: %w", err)
}
```

Context propagation:
```go
func Fetch(ctx context.Context, id string) error {
    return svc.Get(ctx, id)
}
```
