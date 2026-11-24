# Model Context Protocol (MCP) SDK for Zap.
#
# This is a repository scaffold. The public surface — JSON-RPC 2.0 message
# framing, the stdio transport and lifecycle (initialize/initialized/shutdown),
# server and tool registration (tools/list, tools/call), and a client session —
# is tracked by the epic at https://github.com/zaplang-io/mcp/issues/1 and is not
# implemented yet.
#
# Parity target: the official MCP Python SDK (https://github.com/modelcontextprotocol/python-sdk).
# The MCP specification is the normative tie-breaker. See AGENTS.md and DECISIONS.md.


# The MCP spec revision this SDK advertises as its default during the initialize
# handshake. The handshake negotiates the effective revision; the pinned default
# is an open design decision (see DECISIONS.md).
def protocol_version() -> str:
    return "2025-11-25"
