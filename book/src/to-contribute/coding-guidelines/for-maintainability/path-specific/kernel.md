# `kernel/`

Guidelines that apply only to code under `kernel/`.

### Track callers when converting errors (`track-error-caller`) {#track-error-caller}

Add `#[track_caller]` to every conversion function
that constructs a new kernel `Error` from another error type,
including `From::from` implementations and intermediate conversion helpers.
Without the attribute, the recorded location points inside the conversion function
instead of the caller that encountered the error.

```rust
impl From<core::str::Utf8Error> for Error {
    #[track_caller]
    fn from(_: core::str::Utf8Error) -> Self {
        Error::with_message(Errno::EINVAL, "invalid UTF-8 string")
    }
}
```

See also:
[Rust Reference: The `track_caller` attribute](https://doc.rust-lang.org/reference/attributes/codegen.html#the-track_caller-attribute);
the conversions in `kernel/core/src/error.rs`.

### Use `return_errno!` to return errors (`return-errno`) {#return-errno}

Use `return_errno!` when constructing a kernel error
and immediately returning it from the current function.
This keeps error-return paths concise and consistent.

```rust
// Good
return_errno!(Errno::EINVAL, "the file offset is not page-aligned");

// Bad — spells out the construction and return
return Err(Error::with_message(
    Errno::EINVAL,
    "the file offset is not page-aligned",
));
```

For errors without a message, use `return_errno!(errno)`
instead of `return Err(Error::new(errno))`.

See also:
[`error-message-format`](../naming.md#error-message-format);
the `return_errno!` macro in `kernel/core/src/error.rs`.
