#!/bin/bash

# Agent-Based Development Setup Script
# This script configures the project for different AI assistants

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to display usage
usage() {
    cat << EOF
Usage: $0 --ai <assistant> [--tdd]

Options:
  --ai <assistant>    Specify the AI assistant to configure for
                      Valid options: claude, copilot, cursor
  --tdd               Include Test Driven Development guidelines in AGENTS.md

Examples:
  $0 --ai copilot
  $0 --ai cursor --tdd
  $0 --ai claude

EOF
    exit 1
}

# Parse command line arguments
AI_ASSISTANT=""
ENABLE_TDD=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --ai)
            AI_ASSISTANT="$2"
            shift 2
            ;;
        --tdd)
            ENABLE_TDD=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate AI assistant selection
if [[ -z "$AI_ASSISTANT" ]]; then
    print_error "No AI assistant specified"
    usage
fi

# Convert to lowercase for comparison
AI_ASSISTANT=$(echo "$AI_ASSISTANT" | tr '[:upper:]' '[:lower:]')

# Get script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

print_info "Setting up project for $AI_ASSISTANT..."
print_info "Project root: $PROJECT_ROOT"

# Function to setup for GitHub Copilot
setup_copilot() {
    print_info "Configuring for GitHub Copilot..."

    # Create .github directory
    GITHUB_DIR="$PROJECT_ROOT/.github"
    mkdir -p "$GITHUB_DIR"
    print_info "Created directory: $GITHUB_DIR"

    # Create .github/prompts directory
    PROMPTS_DIR="$GITHUB_DIR/prompts"
    mkdir -p "$PROMPTS_DIR"
    print_info "Created directory: $PROMPTS_DIR"

    # Copy and rename prompt files with .prompt.md extension
    if [[ -f "$PROJECT_ROOT/prompts/spec.md" ]]; then
        cp "$PROJECT_ROOT/prompts/spec.md" "$PROMPTS_DIR/spec.prompt.md"
        print_info "Copied spec.md to $PROMPTS_DIR/spec.prompt.md"
    else
        print_warning "spec.md not found in prompts directory"
    fi

    if [[ -f "$PROJECT_ROOT/prompts/implement.md" ]]; then
        cp "$PROJECT_ROOT/prompts/implement.md" "$PROMPTS_DIR/implement.prompt.md"
        print_info "Copied implement.md to $PROMPTS_DIR/implement.prompt.md"
    else
        print_warning "implement.md not found in prompts directory"
    fi

    # Create copilot-instructions.md file
    cat > "$GITHUB_DIR/copilot-instructions.md" << 'EOF'
# GitHub Copilot Instructions

This project follows an agent-based development workflow. Please reference the AGENTS.md file for detailed guidelines and workflow instructions.

@AGENTS.md
EOF
    print_info "Created copilot-instructions.md at $GITHUB_DIR/copilot-instructions.md"

    # Update AGENTS.md
    AGENT_INFO="GitHub Copilot (VS Code)"

    update_agents_md "$AGENT_INFO"
}

# Function to setup for Cursor
setup_cursor() {
    print_info "Configuring for Cursor..."

    # Create /agents directory for agent definitions
    AGENTS_DIR="$PROJECT_ROOT/agents"
    mkdir -p "$AGENTS_DIR"
    print_info "Created directory: $AGENTS_DIR"

    # Copy prompt files to /agents directory
    if [[ -f "$PROJECT_ROOT/prompts/spec.md" ]]; then
        cp "$PROJECT_ROOT/prompts/spec.md" "$AGENTS_DIR/spec.md"
        print_info "Copied spec.md to $AGENTS_DIR/spec.md"
    else
        print_warning "spec.md not found in prompts directory"
    fi

    if [[ -f "$PROJECT_ROOT/prompts/implement.md" ]]; then
        cp "$PROJECT_ROOT/prompts/implement.md" "$AGENTS_DIR/implement.md"
        print_info "Copied implement.md to $AGENTS_DIR/implement.md"
    else
        print_warning "implement.md not found in prompts directory"
    fi

    # Create .cursorrules file
    cat > "$PROJECT_ROOT/.cursorrules" << 'EOF'
# Cursor AI Rules

This project follows an agent-based development workflow. Please reference the AGENTS.md file for detailed guidelines and workflow instructions.

@AGENTS.md
EOF
    print_info "Created .cursorrules at project root"

    # Update AGENTS.md
    AGENT_INFO="Cursor"

    update_agents_md "$AGENT_INFO"
}

# Function to setup for Claude
setup_claude() {
    print_info "Configuring for Claude..."

    # Create .claude/commands directory for custom commands
    CLAUDE_DIR="$PROJECT_ROOT/.claude/commands"
    mkdir -p "$CLAUDE_DIR"
    print_info "Created directory: $CLAUDE_DIR"

    # Copy prompt files
    if [[ -f "$PROJECT_ROOT/prompts/spec.md" ]]; then
        cp "$PROJECT_ROOT/prompts/spec.md" "$CLAUDE_DIR/spec.md"
        print_info "Copied spec.md to $CLAUDE_DIR/spec.md"
    else
        print_warning "spec.md not found in prompts directory"
    fi

    if [[ -f "$PROJECT_ROOT/prompts/implement.md" ]]; then
        cp "$PROJECT_ROOT/prompts/implement.md" "$CLAUDE_DIR/implement.md"
        print_info "Copied implement.md to $CLAUDE_DIR/implement.md"
    else
        print_warning "implement.md not found in prompts directory"
    fi

    # Create CLAUDE.md file at project root
    cat > "$PROJECT_ROOT/CLAUDE.md" << 'EOF'
# Claude Code Instructions

This project follows an agent-based development workflow. Please reference the AGENTS.md file for detailed guidelines and workflow instructions.

@AGENTS.md
EOF
    print_info "Created CLAUDE.md at project root"

    # Update AGENTS.md
    AGENT_INFO="Claude (Desktop App / API)"

    update_agents_md "$AGENT_INFO"
}

# Function to update AGENTS.md
update_agents_md() {
    local agent_info="$1"
    local agents_md="$PROJECT_ROOT/AGENTS.md"
    
    if [[ ! -f "$agents_md" ]]; then
        print_error "AGENTS.md not found at $agents_md"
        exit 1
    fi
    
    # Read the file line by line and replace the placeholder
    local temp_file=$(mktemp)
    local found=false
    
    while IFS= read -r line; do
        if [[ "$line" == *"[INSERT AI ASSISTANT CHOICE HERE:"* ]]; then
            echo "$agent_info" >> "$temp_file"
            found=true
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$agents_md"
    
    if [[ "$found" == false ]]; then
        print_warning "Placeholder not found in AGENTS.md, but continuing..."
    fi
    
    # Move temp file back to original
    mv "$temp_file" "$agents_md"
    
    print_info "Updated AGENTS.md with $AI_ASSISTANT configuration"
    
    # Add TDD section if flag is enabled
    if [[ "$ENABLE_TDD" == true ]]; then
        add_tdd_section "$agents_md"
    fi
}

# Function to add TDD section to AGENTS.md
add_tdd_section() {
    local agents_md="$1"
    
    # Check if TDD section already exists
    if grep -q "## Test Driven Development" "$agents_md"; then
        print_warning "TDD section already exists in AGENTS.md, skipping..."
        return
    fi
    
    print_info "Adding Test Driven Development section to AGENTS.md..."
    
    # TDD content to append
    local tdd_content='

## Test Driven Development

- Before implementation, create test cases based on the specification to ensure that the implementation meets the requirements.
- As each phase of the plan is implemented, a red-green testing approach should be used to validate the implementation against the test cases.
- After implementation, run the test cases to verify that the implementation is correct and meets the specification for the whole feature
- If any test cases fail, update the implementation and/or specification as needed to resolve the issues.
- Document any changes made to the test cases or implementation in the implementation summary file.
- Ensure that all test cases pass before considering the implementation complete.
- Use automated testing tools where possible to streamline the testing process.
- Tests must be appropriate and not overly complex for the feature being implemented.
- Coverage is important, but focus on meaningful tests that validate the core functionality described in the specification.
'
    
    # Append TDD section to the end of the file
    echo "$tdd_content" >> "$agents_md"
    
    print_info "Added TDD section to AGENTS.md"
}

# Main setup logic
case "$AI_ASSISTANT" in
    copilot|github-copilot)
        setup_copilot
        ;;
    cursor)
        setup_cursor
        ;;
    claude)
        setup_claude
        ;;
    *)
        print_error "Invalid AI assistant: $AI_ASSISTANT"
        print_error "Valid options are: claude, copilot, cursor"
        exit 1
        ;;
esac

# Remove the prompts directory after setup
if [[ -d "$PROJECT_ROOT/prompts" ]]; then
    rm -rf "$PROJECT_ROOT/prompts"
    print_info "Removed prompts/ directory"
fi

print_info "${GREEN}✓${NC} Setup complete for $AI_ASSISTANT!"
print_info ""
print_info "Next steps:"
print_info "1. Review the updated AGENTS.md file for usage instructions"
print_info "2. Start using the agent commands in your $AI_ASSISTANT workflow"
print_info "3. Refer to the context/ directory for project architecture and guidelines"
if [[ "$ENABLE_TDD" == true ]]; then
    print_info "4. Review the Test Driven Development section in AGENTS.md for TDD workflow"
fi
print_info ""

exit 0
