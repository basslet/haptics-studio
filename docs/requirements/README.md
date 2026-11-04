# Requirements

This repo's requirements, traced with tracey. Set up by
`_tooling/bin/tracey-init`. How to write a requirement and mark the code and
tests that cover it: the `requirements` skill
(`_tooling/.claude/skills/requirements/SKILL.md`). Look requirements up with
the tracey MCP tools rather than reading these files whole.

Requirements go in `docs/requirements/<area>.md`. This file is part of the
tracey spec too (`.config/tracey/config.styx` includes
`docs/requirements/**/*.md`): a requirement ID at column 0 here, outside a
code fence, defines a real requirement.

## Not traced

Scripts without an extension, which tracey cannot see, that stay that way.
One line each, with the reason. Rename any other one to `.sh`.

- (none)
