# mcp workspace conventions (zaplang-io/mcp)

This is an official non-core Zap module. Target: parity with the official
[**MCP Python SDK**](https://github.com/modelcontextprotocol/python-sdk)
(PyPI `mcp`), with the [MCP specification](https://modelcontextprotocol.io/specification/latest)
as the normative tie-breaker.

## Language-first (non-negotiable)
- All language or stdlib bugs discovered while building this module MUST be reported in `zaplang-io/zap` FIRST, and no workaround is permitted. Keep the dependent work blocked or draft and report the dependency; never build the library around a core defect.

## Python parity & signatures
- Match the official MCP Python SDK's API surface and naming as closely as the language allows. The MCP spec is the tie-breaker when the SDK and spec disagree.
- Where a function/method signature is ambiguous, or Zap's static typing forces a divergence from the Python SDK (e.g. how tool input schemas and tool handlers are expressed without runtime annotation reflection), do NOT just pick one: present the options to the maintainer with concrete examples of what the Python SDK does, and let the maintainer decide. Record the chosen design in `DECISIONS.md`.

## Protocol conformance
- Wire messages MUST follow JSON-RPC 2.0 and the targeted MCP spec revision. The protocol revision is negotiated during the `initialize` handshake; do not hard-code assumptions that break negotiation.
- When the spec and the Python SDK diverge on the wire, conform to the spec and record the divergence in `DECISIONS.md`.

## Tests
- All test cases live in the `tests/` folder and use the `zap test` methodology (`zap test tests/`).
- Every PR MUST include extensive positive AND negative test cases — treat tests as a walled garden and as intent documentation, not a minimal smoke check. Cover edge cases, error paths, malformed JSON-RPC, protocol-version mismatches, and abuse/bounds inputs.
- When fixing a bug, write the failing test first, then fix.

## CI
- CI runs against `ghcr.io/zaplang-io/zap:latest` and MUST continue to pin `zap:latest` until this module reaches a proper major (1.0) version release; only then pin a released toolchain version.

## Issues & PRs
- Keep issues concrete and testable with detailed bodies (repro or intended syntax, the MCP Python SDK equivalent, spec references).
- Multi-issue features get an Epic with trackable sub-issues. Individual issues are 'M' sized.
- One issue, one PR. Rebase onto the latest default branch before raising or updating a PR.
- Documentation (README, DECISIONS.md, CHANGELOG) stays current with every PR.

## Attribution
- No agent attribution in issue bodies/titles, commit messages, or PR titles/bodies — the maintainer's name only. Review and issue/PR *comments* may carry attribution ("Reviewed by …", "Claude input on …").
