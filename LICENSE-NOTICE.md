# License Boundary

This repository contains deployment examples, documentation, health checks,
sanitized status-exporter examples, and a narrow fail-closed build-time
compatibility patch. It does not vendor the `emby-keeper/emby-keeper` source
tree.

Embykeeper is an external project with its own GPL-3.0 license and release
process. Obtain it from its official distribution channel, review its license
and release digest, and keep its runtime separate from this repository.

The v7.6.1 compatibility patch modifies files inside the pinned official image
at build time. The patch and any resulting derived image must be handled under
the upstream GPL-3.0 terms, with the upstream source/tag and image digest kept
available. Do not publish a derived image without the corresponding source and
license obligations being satisfied.

This notice is not legal advice. Any source-level integration or redistribution
requires an owner and license review first.
