# Landing Page

Personal landing page and blog using Hugo and the PaperMod theme.

## Archive Migration Instructions

This project is migrating personal content from an old Sphinx blog at `../archive/`. 

### Migration Process

1. **Check todo.md** for complete file tracking and status
2. **Content Organization**:
   - Personal/life content → `content/blog/YEAR/`
   - Book reviews/reading → `content/reading/YEAR/` 
   - Creative writing → `content/writing/prose/`
   - Pet/family stories → `content/blog/YEAR/`

3. **RST to Markdown Conversion**:
   - Convert Sphinx metadata to Hugo frontmatter
   - Transform footnotes: `.. [#label]` → `[^label]:`
   - Update image paths: `/_static/images/` → `/images/`
   - Convert directives: `.. figure::` → `![alt](path)` 
   - Transform cross-refs and internal links
   - Add `draft: true` to all migrated content

4. **Priority Order**:
   - High-value personal stories (Toriyama tribute, swimming journey)
   - Mahabharata reading series (2016-2017 daily posts)
   - Book reviews and reading correspondence
   - Creative writing and family stories
   - Selected drafts with personal value

5. **Asset Migration**:
   - Copy images from `../archive/source/_static/images/` to `static/images/`
   - Update all image references in converted posts
   - Preserve photo series and collections

### Conversion Examples

**RST Frontmatter:**
```rst
.. meta::
    :description: Post description
    :keywords: tag1, tag2
    :date: 2024-03-19
```

**Hugo Frontmatter:**
```yaml
---
title: "Post Title"
date: 2024-03-19T00:00:00Z
description: "Post description"
tags: ["tag1", "tag2", "personal"]
draft: true
---
```

**RST Images:**
```rst
.. figure:: /_static/images/posts/example.jpg
    :width: 720
    :alt: Description
    
    Caption text
```

**Markdown Images:**
```markdown
![Description](/images/posts/example.jpg)
*Caption text*
```

See `todo.md` for complete file-by-file migration tracking.