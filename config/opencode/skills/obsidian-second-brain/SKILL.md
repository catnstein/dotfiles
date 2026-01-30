---
name: obsidian-second-brain
description: Navigate and build Obsidian second brain. Use for finding notes by topic, creating rough notes, processing notes to main, or browsing indexes.
---

## Vault
`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/second brain`

## Structure
| Folder | Purpose |
|--------|---------|
| 01 - Rough Notes | Quick captures, status `#new` |
| 02 - Source Materials | URLs, PDFs, diagrams (no template) |
| 03 - Indexes | TOC files grouping main notes |
| 04 - Templates | Note templates |
| 05 - Main Notes | Polished notes, status `#reviewed` |

## Find
- By topic: search content in `01`/`05` folders
- By tag: search `#tagname`
- By link: search `[[note name]]`

## Create Rough Note
**Confirm with user before writing.**

Location: `01 - Rough Notes/<title>.md`

Format:
```
<YYYY-MM-DD> <HH:MM>

Status: #new

Tags: <user-specified>

# <title>

<content>

# References:
<[[links]] if any>
```

## Process Note
1. Review rough note with user
2. Refine content together
3. When agreed: change status to `#reviewed`, move to `05 - Main Notes/`
4. Update relevant index in `03 - Indexes/`

## Linking
- Internal: `[[Note Name]]`
- Tags: `#topic` (e.g., `#sci`, `#dev`)
