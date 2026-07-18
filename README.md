# Landing Page

Personal landing page and blog using Hugo and the PaperMod theme.

## Content Structure

This site has separate sections for different types of content:

### Blog (`/blog`)

For personal thoughts, life experiences, and non-technical content.

**How to add a blog post:**

```bash
hugo new blog/my-new-post.md
```

### Reading (`/reading`)

For book reviews, reading thoughts, and literary content.

**How to add a reading post:**

```bash
hugo new reading/book-title.md
```

### Cooking (`/cooking`)

For documenting meals, recipes, and what you're eating.

**How to add a cooking post:**

```bash
hugo new cooking/meal-title.md
```

### Private/Unlisted Posts

For content that should be accessible via direct URL but not listed publicly.

**How to add a private post:**

```bash
hugo new unlisted/private-post.md
```

Then add these parameters to the frontmatter:

```yaml
private: true
hiddenInHomeList: true
```

## Frontmatter Requirements

All posts should include:

```yaml
---
title: "Post Title"
date: 2025-01-20T10:00:00Z
description: "A clear, concise description for SEO and previews"
tags: ["tag1", "tag2"]
# For private posts only:
private: true
hiddenInHomeList: true
---
```

## Admonition System

This site supports rich admonitions (callout boxes) for enhanced content:

### Available Types

- `note` - Blue themed, for important information
- `info` - Cyan themed, for general information
- `warning` - Orange themed, for warnings and cautions
- `tip` - Green themed, for helpful tips
- `quote` - Gray themed, for quotes and citations
- `example` - Purple themed, for code examples and demos
- `ai` - Orange themed, for AI-generated content disclosure

### Usage

```markdown
{{< note title="Custom Title" >}} Your note content here. Supports **markdown**.
{{< /note >}}

{{< quote title="Inspiration" footer="Author Name" >}} Quote text here
{{< /quote >}}

{{< ai >}} This section was written with AI assistance. {{< /ai >}}
```

## Features

### Private Posts

- Posts marked with `private: true` are excluded from:
  - Home page listings
  - Archive pages
  - Tag pages
  - RSS feeds
- Include `noindex, nofollow` meta tags for SEO
- Still accessible via direct URL for selective sharing

### SEO Optimization

- All pages require `description` frontmatter
- Proper meta tags and structured data
- Private post handling for search engines

### Development

**Requirements:**

- Hugo v0.146.7 (extended version required)

**Theme setup:**

PaperMod is vendored in-repo under `themes/PaperMod` — no submodule init needed after cloning.

**Install Hugo Extended:**

```bash
# On Ubuntu/Debian
wget https://github.com/gohugoio/hugo/releases/download/v0.146.7/hugo_extended_0.146.7_linux-amd64.deb
sudo dpkg -i hugo_extended_0.146.7_linux-amd64.deb

# Or via package manager if available
snap install hugo --channel=extended
```

**Start local server:**

```bash
hugo server --buildDrafts
```

**Build for production:**

```bash
hugo
```

**Test GitHub Actions workflow locally:**

```bash
gh act -j build
```

This runs the build job locally using Docker, testing the same environment as
GitHub Actions. The upload step is automatically skipped when running locally.
Generated site will be in `./public/`.

## Theme

Uses a vendored copy of the [PaperMod theme](https://github.com/adityatelange/hugo-PaperMod)
(`themes/PaperMod`) with custom modifications for:

- Admonition system with full light/dark mode support
- Private post filtering in listings
- Enhanced archive layouts
- Custom CSS extensions

## Directory Structure

```
content/
├── blog/                    # Personal blog posts
├── reading/                 # Book reviews and reading content
├── cooking/                 # Meal logs and cooking notes
├── unlisted/               # Private posts (excluded from listings)
└── no-social-media.md
themes/PaperMod/             # Vendored PaperMod theme
layouts/
├── baseof.html              # Theme shell + homepage class
├── list.html                # List pages with private filtering
├── single.html              # Posts with lastmod + newsletter
├── archives.html            # Archives with private filtering
├── cooking/list.html        # Cooking filters/badges
├── _partials/
│   ├── extend_head.html     # Private robots + admonition sprites
│   ├── footer.html          # Custom footer (no powered-by credit)
│   └── newsletter.html      # Picoletter embed
└── shortcodes/              # Admonition + gallery shortcodes
assets/css/extended/
└── custom.css               # Site styles (admonitions, cooking, tags)
```
