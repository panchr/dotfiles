# React Guidelines (best practices)

Summary from React docs (abridged):
- Components are functions that return JSX.
- JSX must return a single parent and close tags properly.
- Props are read-only; use state for local changes.
- State updates trigger re-renders; keep state minimal and derived when possible.
- Hooks must be called at the top level of components or custom hooks.
- Lists should use stable keys from data, not indexes.

Focus on:
- Follow Rules of Hooks (no conditional hooks).
- Stable keys for lists; avoid index keys if order can change.
- Avoid unnecessary re-renders; memoize when justified.
- Keep state minimal and colocated; derive when possible.
- Ensure accessibility (aria labels, keyboard navigation).
- Avoid side effects in render; use effects for synchronization.

Always flag:
- Hooks called conditionally or in loops.
- Missing keys or unstable keys for lists.
- Side effects inside render.
- State updates during render.

Examples (always flag):

- Conditional hook:

```tsx
function Comp({ enabled }: { enabled: boolean }) {
  if (enabled) {
    useEffect(() => {
      track();
    }, []);
  }
  return null;
}
```

- Missing or unstable list keys:

```tsx
items.map((item, i) => <Row key={i} item={item} />)
```

- Side effects during render:

```tsx
function Comp() {
  fetch("/api/data");
  return <div />;
}
```

- State update during render:

```tsx
function Comp() {
  const [count, setCount] = useState(0);
  setCount(count + 1);
  return <div>{count}</div>;
}
```

Examples:

- Hooks not conditional:

```tsx
function Comp({ enabled }: { enabled: boolean }) {
  const [count, setCount] = useState(0);
  if (!enabled) return null;
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
}
```

- Stable list keys:

```tsx
items.map((item) => <Row key={item.id} item={item} />)
```
