# Agent-Based Development Workflow

This project uses a simplified specification and implementation agent-based workflow to streamline development.

## Getting Started

- Run the `setup.sh` script to create the general structure for the chosen AI Assistant.
- This file will move the prompts to the necessary command file structure for the chosen AI Assistant.
- Update the `AGENTS.md` file with the chosen AI Assistant and any additional instructions specific to that assistant.

## AI Assistant

[INSERT AI ASSISTANT CHOICE HERE: e.g. Claude, Co-pilot, Cursor, etc.]

## Available Agent Commands

You can invoke specific agents by referencing them in your prompts:

- **spec.md** - Creates detailed specifications from requirements
- **implement.md** - Implements features based on plans

## Workflow

1. Use spec.md to clarify requirements and create specifications from the problem
2. Use implement.md to execute the plan

## Agent Definitions

Each agent has specific responsibilities and outputs defined in the prompts.

## Scratch Directory

- The `scratch/` directory is used for temporary files and notes.
- ALL AGENT GENERATED MD FILES MUST BE WRITTEN TO THE `scratch/` DIRECTORY.

## Context Directory

- All relevant project files that provide context for the agents should be stored in the `context/` directory.
  - This includes a `architecture.md` file that outlines the overall architecture of the project.
- Agents should reference files in the `context/` directory to inform their decisions and outputs on every single prompt.
- Agents should NOT write or modify files in the `context/` directory unless explicitly instructed to do so by the user.

## Specifications

- spec.md: Responsible for generating detailed specifications from high-level requirements.
- All spec files should be stored in the `specs/` directory.
- All specifications should be prefixed with a timestamp in the following format: `YYYYMMDD_HHMMSS_`.
- Specifications should be written in clear, concise language and include acceptance criteria.
- Specifications should not include implementation details or technical decisions.

## Implementation

- Before implementation, review the relevant specification file in the `specs/` directory.
- Before implementation, confirm with the user any questions or clarifications needed regarding the specification.
- Before implementation, create a checklist or plan based on the specification to guide the implementation process.
  - Run this plan by the user for confirmation before proceeding. This file should **not** be written to an md file
- implement.md: Responsible for implementing features based on the specifications.
- After implementation, write a brief summary of the changes made and any relevant notes for future reference.
  - All implementation summary files should be written to a `scratch/` directory. These files will not be stored in version control, but are a reference to help you keep track of what has been done.
- After implementation, update the relevant specification file to reflect any changes made during development.
  - Prompt the user to confirm what updates should be made to the specification file.
