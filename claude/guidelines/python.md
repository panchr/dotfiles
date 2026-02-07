# Python Guidelines (PEP 8 + idiomatic Python)

Summary from PEP 8 (abridged):
- Readability counts; consistency within a project matters most.
- Indent with 4 spaces; avoid mixing tabs and spaces.
- Max line length 79 (docstrings/comments 72).
- Imports: standard, third-party, local; one per line; use blank lines between groups.
- Naming: snake_case functions/vars, CapWords classes, UPPER_CASE constants.
- Avoid extraneous whitespace; keep comments clear and up to date.
- Use `is`/`is not` for `None` comparisons.

Focus on:
- Clear, pythonic style (readability > cleverness).
- Proper exception handling; avoid bare except.
- Prefer context managers for resources.
- Avoid mutable default arguments.
- Use type hints where the project expects them.
- Keep functions small and cohesive; avoid deep nesting.

Always flag:
- Bare `except` or swallowed exceptions.
- Resource leaks (files, sockets).
- Mutable default arguments (e.g., `def f(x=[]):`).
- `except Exception: pass` without logging or re-raise.

Examples (always flag):

- Bare except:

```python
try:
    do_work()
except:
    handle_error()
```

- Swallowed exception:

```python
try:
    do_work()
except Exception:
    pass
```

- Resource leak (no context manager):

```python
f = open(path, "r")
data = f.read()
# Bad: f not closed
```

- Mutable default:

```python
def add_item(item, items=[]):
    items.append(item)
    return items
```

Examples:

- Avoid mutable defaults:

```python
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

- Use context managers:

```python
with open(path, "r") as f:
    data = f.read()
```
