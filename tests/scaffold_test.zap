import mcp


# Smoke test for the scaffold: the module imports and exposes the default
# protocol revision. Replaced by real coverage as the surface lands (see #2).
@test
def _advertises_default_protocol_version():
    assert mcp.protocol_version() == "2025-11-25"
