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

# PIAC (Puppet In A Cloud)

EKS-based dev environment for Puppet code. Each user gets a pod with access to role VMs in AWS.

## Access
- `ssh piac` (configured in ~/.ssh/config)
- `piac` command is an alias for `sudo -E /home/piacsvc/piac.pex`
- Non-interactive: `ssh piac "HOSTNAME=\$(hostname) sudo -E /home/piacsvc/piac.pex <command>"`

## Commands
- `piac validate <module>` — lint, parser, template validation, rspec
- `piac up <role>` — spin up rolevm, push /etc/puppet, run puppet-apply
- `piac ssh <role>` — SSH into rolevm (interactive only)
- `piac push <role>` — push code to existing rolevm
- `piac destroy <role>` — tear down rolevm
- `piac list` — show active VMs

## Running commands on role VMs non-interactively
- `ssh piac "sudo ssh -oStrictHostKeyChecking=no -i /etc/sshkey-volume/ec2-pit.pem cloud-user@<IP> '<command>'"`
- User: `cloud-user` (RHEL9/OEL9), `centos` (older)
- `puppet-apply` alias resolves to: `sudo /opt/puppetlabs/puppet/bin/puppet apply /etc/puppet/manifests/site.pp --detailed-exitcodes --certname <fqdn> --config /etc/puppet/puppet5-masterless.conf --write-catalog-summary`
- Exit codes: 0 = no changes, 2 = changes applied, other = error
- Role VM IP appears in `piac up` output

## Key details
- Containers and VMs auto-delete after 7 days
- Apply logs copied back to PIAC at /var/tmp/piac-apply1-<role>.log
- HowTo doc: Google Doc ID `12mtcVyQMJ5-8O1kuCiGeu_4iFATf26jvQoQyG1_3x1c`
- PIAC source: `../piac` relative to puppet module repos

