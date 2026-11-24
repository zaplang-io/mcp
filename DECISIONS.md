# mcp package decisions

Design decisions for the Zap `mcp` library, keyed to issues. Each records a
choice that could not be read straight off the official
[MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk) or the
[MCP specification](https://modelcontextprotocol.io/specification/latest), with
the reference it follows or departs from. Signature ambiguities and typing-forced
divergences are resolved with the maintainer (with concrete Python examples)
before being recorded here.

## Parity target: MCP Python SDK

The package tracks the official [MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk)
(PyPI [`mcp`](https://pypi.org/project/mcp/)) as its primary API reference. The
[MCP specification](https://modelcontextprotocol.io/specification/latest) and
[JSON-RPC 2.0](https://www.jsonrpc.org/specification) are the tie-breakers when
the SDK and the normative wire format disagree. Deviations are recorded below,
keyed to the issue that introduces them.

## Open decisions (to be resolved with the maintainer)

These are flagged in the epic ([#1](https://github.com/zaplang-io/mcp/issues/1))
and the docs-first issue ([#2](https://github.com/zaplang-io/mcp/issues/2)); none
is settled yet.

- **Pinned protocol revision.** The handshake negotiates the revision, but the
  SDK must advertise a default. Proposed: target spec revision `2025-11-25` (the
  latest dated stable revision) and negotiate down. Final pin TBD.
- **Tool input schemas without annotation reflection.** The Python SDK derives a
  tool's JSON Schema from Python type hints at runtime. Zap is AOT and statically
  typed with no equivalent runtime reflection, so schemas must be declared
  explicitly or generated at build time. The exact surface is a forced divergence
  from `FastMCP`'s decorator ergonomics and must be decided with the maintainer.
- **Tool handler shape.** Whether handlers are first-class `fn(...) -> ...`
  values registered against a `Tool`, interface implementations, or a decorator
  facade layered later. The first cut favors explicit function-value registration.
- **Async / concurrency model.** The Python SDK is `async`-first. Zap uses
  coroutines and `scope`/`spawn`; how the serve loop and client session map onto
  that (and whether the first cut is synchronous over stdio) is TBD.
- **Error surface.** How JSON-RPC error codes map to Zap `@exception` structs vs.
  typed result values (`CallToolResult.isError`), matching the SDK's split
  between protocol errors and tool-execution errors.

Decisions move from this list into keyed sections below as each issue lands.
