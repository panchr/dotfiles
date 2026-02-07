# JavaScript/TypeScript Guidelines (best practices)

Focus on:
- Prefer `const` and immutable data where practical.
- Avoid `any` in TypeScript; use narrow, explicit types.
- Handle null/undefined safely; avoid implicit coercion.
- Prefer async/await over raw Promises; handle rejections.
- Keep functions small; avoid side effects in shared state.
- Validate external inputs and guard against XSS/SQLi where relevant.

Always flag:
- Missing error handling for async code.
- Unsafe type assertions or pervasive `any`.
- Unvalidated external inputs.
- Direct DOM injection without sanitization.

Examples (always flag):

- Missing async error handling:

```ts
// Bad: rejection not handled
async function load() {
  const data = await fetchData();
  return data;
}
```

- Unsafe `any`:

```ts
// Bad: erases type safety
const user: any = parseUser(input);
```

- Unvalidated input:

```ts
// Bad: user input passed through unchecked
const id = req.query.id as string;
await db.get(id);
```

- DOM injection:

```ts
// Bad: unsanitized HTML
el.innerHTML = userInput;
```

Examples:

- Avoid unsafe `any`:

```ts
type User = { id: string; name: string };
const user: User = parseUser(input);
```

- Handle async errors:

```ts
try {
  const data = await fetchData();
} catch (err) {
  logger.error(err);
}
```
