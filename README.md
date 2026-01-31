# Simple Spec Starter

A lightweight, agent-based workflow for building software through specification-first development. This starter kit helps you break down requirements into clear specs, then implement them systematically.

> **Note:** This workflow has been tested primarily with Claude (Desktop App/API). Support for other AI assistants is experimental.

## Overview

This project uses a two-agent workflow:

1. **Spec Agent** - Transforms requirements into detailed specifications
2. **Implement Agent** - Builds features based on approved specifications

The workflow encourages clear thinking about requirements before writing code, reducing rework and improving code quality.

## Quick Start

1. Run the setup script to configure for your AI assistant:
   ```bash
   bash scripts/setup.sh
   ```

2. Follow the prompts to select your AI assistant (Claude, Copilot, or Cursor)

3. Start using the agents in your development workflow (see below)

## How to Use with Different AI Assistants

### Claude (Desktop App / API)

**Setup:**
- Run `bash scripts/setup.sh` and select "Claude"
- The script configures custom instructions and agent commands
- Agent prompts are stored in [.claude/](.claude/)

**Usage:**
- The spec and implement agents are configured as Claude skills
- Skills are invoked automatically when you request a spec or ask to implement a technical plan
- You can also manually invoke them using `/spec` or `/implement`

**Example workflow:**
```
1. "Create a specification for user authentication" (auto-invokes /spec skill)
2. Review and approve the generated spec in specs/
3. "Implement the authentication spec" (auto-invokes /implement skill)
4. Review implementation and iterate as needed
```

### GitHub Copilot

**Setup:**
- Run `bash scripts/setup.sh` and select "Copilot"
- The script configures agent instructions in `.github/copilot-instructions.md`

**Usage:**
- The spec and implement agents are configured in Copilot's workspace instructions
- Explicitly invoke agents by asking Copilot to act as the spec or implement agent

**Example workflow:**
```
1. "Act as the spec agent and create a specification for user authentication"
2. Review the generated spec in specs/
3. "Act as the implement agent and implement the authentication spec"
```

### Cursor

**Setup:**
- Run `bash scripts/setup.sh` and select "Cursor"
- The script configures agent instructions in `.cursorrules`

**Usage:**
- The spec and implement agents are configured in Cursor's `.cursorrules` file
- Explicitly invoke agents by asking Cursor to act as the spec or implement agent

**Example workflow:**
```
1. "Act as the spec agent and create a specification for user authentication"
2. Review and approve the generated spec
3. "Act as the implement agent and implement the authentication spec"
```

## Project Structure

- **[.claude/](.claude/)** - Claude-specific agent prompts and commands
- **[context/](context/)** - Project context files (architecture, patterns, etc.)
- **[specs/](specs/)** - Generated specification files
- **[scratch/](scratch/)** - Temporary agent output and implementation notes
- **[AGENTS.md](AGENTS.md)** - Complete workflow documentation and agent guidelines

## Workflow Details

See [AGENTS.md](AGENTS.md) for complete documentation on:
- Agent responsibilities and outputs
- Directory structure and conventions
- Code quality standards (KISS, DRY principles)
- Specification format and requirements
- Implementation process and best practices

## Contributing

This is a starter template. Fork it and customize the agents, workflow, and structure to fit your project needs.
