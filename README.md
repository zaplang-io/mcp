# mcp

Model Context Protocol (MCP) SDK for [Zap](https://github.com/zaplang-io/zap) — an official **non-core** package.

- Tracking issue: [zaplang-io/zap#327](https://github.com/zaplang-io/zap/issues/327)
- Contributor & agent conventions: [AGENTS.md](AGENTS.md)
- Design decisions: [DECISIONS.md](DECISIONS.md)

Build MCP **servers** and **clients** in Zap: expose typed tools, resources, and
prompts to MCP-capable hosts, and consume the same from other servers, over
JSON-RPC 2.0. The [Tier-1 epic](https://github.com/zaplang-io/mcp/issues/1)
tracks the message framing, transports, and the server/client surfaces.

## Goals

A typed Zap MCP SDK whose public API mirrors the official
[**MCP Python SDK**](https://github.com/modelcontextprotocol/python-sdk)
(PyPI [`mcp`](https://pypi.org/project/mcp/)) as closely as Zap's static typing
allows. The Python SDK is the primary API reference; the
[MCP specification](https://modelcontextprotocol.io/specification/latest) is the
tie-breaker when the SDK and the spec disagree. API-parity with the Python SDK is
a project rule — see [AGENTS.md](AGENTS.md).

Protocol target: the SDK negotiates the protocol revision during the
`initialize` handshake. The first cut targets spec revision **`2025-11-25`**
(the latest dated stable revision) and advertises it during negotiation; the
exact pinned default is an open design decision recorded in
[DECISIONS.md](DECISIONS.md).

Planned scope (first cut):

- **JSON-RPC 2.0 message framing** — requests, responses, notifications, batches,
  and the error model, with typed message structs.
- **stdio transport + lifecycle** — the `initialize` / `initialized` handshake,
  capability and version negotiation, and orderly shutdown.
- **Server + tool registration** — register typed tools and serve `tools/list`
  and `tools/call`.
- **Client session** (first slice or deferred) — connect to a server, run the
  handshake, and call `tools/list` / `tools/call`.

Deferred to later issues (named in the [epic](https://github.com/zaplang-io/mcp/issues/1),
not yet filed): **resources** (`resources/list` / `resources/read` / templates),
**prompts** (`prompts/list` / `prompts/get`), **sampling** (`sampling/createMessage`),
**SSE and Streamable-HTTP transports**, **notifications** (list-changed,
progress, cancellation, logging), **completion**, and a high-level `FastMCP`-style
decorator facade.

## Public-surface sketch (not final)

The Python SDK's high-level entry point is `FastMCP`:

```python
# Python: official MCP SDK (mcp.server.fastmcp)
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("demo")

@mcp.tool()
def add(a: int, b: int) -> int:
    return a + b

mcp.run()  # stdio transport
```

The Zap first cut exposes an explicit, typed server surface (a decorator facade
is deferred). Signatures below are **illustrative and not final**:

```zap
import mcp

server = mcp.Server(name="demo", version="0.1.0")

# Register a typed tool. The schema is derived/declared explicitly rather than
# reflected from annotations (Zap is AOT and statically typed).
server.add_tool(
    mcp.Tool(
        name="add",
        description="Add two integers.",
        input_schema=mcp.object_schema({"a": mcp.int_schema(), "b": mcp.int_schema()}),
    ),
    fn(mcp.CallToolRequest req) -> mcp.CallToolResult:
        a = req.arguments["a"].as_int()
        b = req.arguments["b"].as_int()
        return mcp.text_result(str(a + b)),
)

# Serve JSON-RPC over stdio; blocks running the initialize/serve loop.
server.run_stdio()
```

```zap
import mcp

# Minimal client (first slice or deferred — see the epic).
client = mcp.Client(name="inspector", version="0.1.0")
session = client.connect_stdio(command="./my-server", args=[])
session.initialize()
tools = session.list_tools()
result = session.call_tool(name="add", arguments={"a": 2, "b": 3})
print(result.text())
```

The exact signatures (keyword vs positional, defaults, how tool handlers and
tool input schemas are expressed in a statically typed AOT language, return
shapes) are **not final**. Any ambiguity or forced divergence from the Python
SDK is escalated to the maintainer with concrete Python examples and recorded in
[DECISIONS.md](DECISIONS.md) rather than decided unilaterally.

## Build and test

Run the native `zap test` suite against a temporary consumer that installs this
checkout as a package:

```
sh tools/test.sh
```

GitHub Actions runs the suite on pull requests and pushes inside the
`ghcr.io/zaplang-io/zap:latest` container. CI stays pinned to `zap:latest`
until this module reaches a 1.0 release.

## Development

Read **[AGENTS.md](AGENTS.md)** before contributing — it covers the MCP Python
SDK-parity rule, the one-issue-one-PR flow, how design decisions are recorded in
**[DECISIONS.md](DECISIONS.md)**, and the rule for reporting core Zap
language/stdlib defects upstream in `zaplang-io/zap` (rather than working around
them here).
