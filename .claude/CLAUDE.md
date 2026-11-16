# Important
No comments unless I ask.
No refactoring unless I ask.
Always use existing patterns in the codebase.
Prefer simple solutions.
Always write documentation in E-Prime.

## Approach
- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.

### Code Intelligence

Prefer LSP over Grep/Glob/Read for code navigation:
- `goToDefinition` / `goToImplementation` to jump to source
- `findReferences` to see all usages across the codebase
- `workspaceSymbol` to find where something is defined
- `documentSymbol` to list all symbols in a file
- `hover` for type info without reading the file
- `incomingCalls` / `outgoingCalls` for call hierarchy

Before renaming or changing a function signature, use
`findReferences` to find all call sites first.

Use Grep/Glob only for text/pattern searches (comments,
strings, config values) where LSP doesn't help.

After writing or editing code, check LSP diagnostics before
moving on. Fix any type errors or missing imports immediately.

## Memory
- Dual-write durable memories to both the local file-based memory system and the `mnemosyne` MCP server (mnemosyne_remember / mnemosyne_remember_canonical), so other agents sharing mnemosyne stay in sync.
- Use scope='global' and extract_entities=True for durable, cross-session facts (machine names, people, standing preferences).

## Information Quality
- Always cite sources for factual claims.
- Prefer Wikipedia as a citation source.
- Never cite Grokipedia or Conservapedia.

<!-- CODEGRAPH_START -->
## CodeGraph

In repositories indexed by CodeGraph (a `.codegraph/` directory exists at the repo root), reach for it BEFORE grep/find or reading files when you need to understand or locate code:

- **MCP tool** (when available): `codegraph_explore` answers most code questions in one call — the relevant symbols' verbatim source plus the call paths between them, including dynamic-dispatch hops grep can't follow. Name a file or symbol in the query to read its current line-numbered source. If it's listed but deferred, load it by name via tool search.
- **Shell** (always works): `codegraph explore "<symbol names or question>"` prints the same output.

If there is no `.codegraph/` directory, skip CodeGraph entirely — indexing is the user's decision.
<!-- CODEGRAPH_END -->

## Agent Vault (added by Sasuke, 2026-11-14)

- A shared Obsidian vault lives at ~/agent-vault on this machine, Syncthing-synced across twh-mba, twhlab01, twhnas01, and twh-win01. The vault holds canonical documents for Thomas's agents: machine notes, project pages, runbooks, and decision records.
- Read ~/agent-vault/README.md before your first vault write. House rules: plain Markdown, frontmatter (title/owner/updated/status), one owner per note, and no secrets ever — credentials stay in the keychain and 1Password.
- After any session that changes machine or project state, append a dated entry to your session log at ~/agent-vault/agents/logs/claude-code.md and update the affected machine or project note.
- The vault complements Mnemosyne: canonical documents live in the vault; episodic recall lives in Mnemosyne. Thomas reads and edits the same files in Obsidian.
- Sasuke (Muse) manages vault structure and coordinates the agent team; Thomas owns the vault.
