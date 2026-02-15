---
name: go-watch-this
description: >
  Parallel multi-angle deep research orchestrator. Spawns multiple Claude sub-agents
  and Codex instances to investigate a topic from different perspectives simultaneously.
  Use when user invokes /go-watch-this, or asks to "deep dive", "research from multiple angles",
  "investigate thoroughly", or wants parallel analysis of a problem.
argument-hint: "[prompt] [sub-agent num] [codex num]"
---

# Go Watch This - Parallel Research Orchestrator

Deep-dive into any question by dispatching multiple AI agents in parallel, each tackling a different angle.

## Argument Parsing

Parse from user input: `/go-watch-this <prompt> [agent_count] [codex_count]`

- `prompt`: The research question or topic (required)
- `agent_count`: Number of Claude sub-agents to spawn (default: 2)
- `codex_count`: Number of Codex calls to make (default: 1)

If counts are not provided as trailing numbers, use defaults.

## Execution Workflow

### 1. Decompose into Research Angles

Before spawning agents, generate `agent_count + codex_count` distinct research angles for the prompt. Each angle must be meaningfully different. Strategies:

- **Breadth**: different facets of the problem (e.g., performance vs correctness vs maintainability)
- **Depth**: surface-level overview vs deep implementation details
- **Perspective**: user's view vs system internals vs external dependencies
- **Contrast**: pros/cons, alternatives, trade-offs

### 2. Create Task Tracking

Use `TaskCreate` to create one parent task for the overall research, then one child task per agent/codex call. This gives the user visibility into progress.

### 3. Select Sub-agent Types

For each Claude sub-agent, pick `subagent_type` based on the angle's nature:

| Angle involves | subagent_type |
|---|---|
| Codebase files, architecture, patterns | `Explore` |
| Web search, docs, external info | `general-purpose` |
| Implementation planning | `Plan` |
| Code review, design evaluation | `architecture-reviewer` |

Use best judgment. When in doubt, use `general-purpose`.

### 4. Launch All Agents in Parallel

**Critical: dispatch ALL agents in a single message with multiple Task tool calls.**

For each Claude sub-agent:
```
Task(
  subagent_type=<selected_type>,
  prompt="Research angle: <angle>\n\nContext: <original_prompt>\n\nInvestigate this specific angle thoroughly. Return structured findings with key insights, evidence, and any open questions.",
  description="Research: <short_angle_label>"
)
```

For each Codex call, use Bash:
```bash
codex exec -s read-only "<angle-specific prompt based on original question>"
```

Launch Claude sub-agents and Codex calls together in the same parallel batch.

### 5. Collect and Synthesize

After all agents complete:

1. Mark all child tasks as completed
2. Read each agent's output
3. Synthesize a unified summary:

```markdown
## Research Summary: <topic>

### Angle 1: <label>
<key findings>

### Angle 2: <label>
<key findings>

...

### Cross-cutting Insights
<patterns, contradictions, or connections across angles>

### Open Questions
<unresolved items needing further investigation>
```

4. Mark parent task as completed

## Example

User: `/go-watch-this "How does ByteTrack handle occlusion?" 3 1`

Decompose into 4 angles:
1. **Algorithm internals** (Explore) — trace ByteTrack code in tracking source files
2. **Academic foundation** (general-purpose) — web search for ByteTrack paper, occlusion strategy
3. **Integration context** (Explore) — how occlusion affects detection pipeline in this codebase
4. **Codex perspective** (Bash/codex) — ask Codex to analyze the tracking implementation

Launch all 4 in parallel, collect results, synthesize.
