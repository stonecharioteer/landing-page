# Landing Page - Justfile Commands
# https://github.com/casey/just

# Default recipe - show available commands
default:
    @just --list

# Initialize repository: check Hugo version and vendored theme
init:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "🔧 Initializing landing page repository..."

    # Check if Hugo is installed and get version
    if ! command -v hugo &> /dev/null; then
        echo "❌ Hugo is not installed. Please install Hugo v0.146.7 or later."
        echo "   Download from: https://github.com/gohugoio/hugo/releases"
        exit 1
    fi

    # Check Hugo version
    HUGO_VERSION=$(hugo version | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    REQUIRED_VERSION="v0.146.7"

    echo "📦 Found Hugo ${HUGO_VERSION}"

    # Simple version check (assumes semantic versioning)
    if ! printf '%s\n' "${REQUIRED_VERSION}" "${HUGO_VERSION}" | sort -V | head -1 | grep -q "${REQUIRED_VERSION}"; then
        echo "⚠️  Hugo version ${HUGO_VERSION} found, but ${REQUIRED_VERSION}+ recommended"
        echo "   Download latest from: https://github.com/gohugoio/hugo/releases"
    else
        echo "✅ Hugo version is compatible"
    fi

    # Check if PaperMod theme is vendored in-repo
    if [[ ! -f "themes/PaperMod/layouts/_default/single.html" ]]; then
        echo "❌ PaperMod theme not found at themes/PaperMod."
        echo "   Expected a vendored copy of the theme in this repository."
        exit 1
    fi

    echo "✅ PaperMod theme is vendored at themes/PaperMod"
    echo "✅ Repository initialized successfully!"
    echo "💡 Run 'just serve' to start development server"

# Build the Hugo site (passes through all arguments)
build *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🔨 Building Hugo site..."
    hugo {{ ARGS }}
    echo "✅ Build complete! Output in ./public/"

# Serve the Hugo site for development on the LAN with drafts enabled
serve *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail
    lan_ip="${HUGO_LAN_IP:-}"
    if [[ -z "${lan_ip}" ]]; then
        lan_ip="$(ipconfig getifaddr en0 2>/dev/null || true)"
    fi
    if [[ -z "${lan_ip}" ]]; then
        lan_ip="$(ipconfig getifaddr en1 2>/dev/null || true)"
    fi
    if [[ -z "${lan_ip}" ]]; then
        lan_ip="$(hostname -I 2>/dev/null | awk '{print $1}' || true)"
    fi
    base_url="${HUGO_BASE_URL:-http://${lan_ip:-localhost}:1313}"
    echo "🚀 Starting Hugo development server..."
    echo "🌐 Bind: 0.0.0.0"
    echo "📝 Drafts: enabled"
    echo "🔗 URL: ${base_url}"
    echo "💡 Extra args are passed through, e.g. just serve --ignoreCache --disableFastRender"
    hugo serve --bind 0.0.0.0 --buildDrafts --baseURL "${base_url}" {{ ARGS }}

# Clean build artifacts
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🧹 Cleaning build artifacts..."

    # Remove Hugo build outputs
    if [[ -d "public" ]]; then
        rm -rf public
        echo "   ✅ Removed public/ directory"
    fi

    # Remove Hugo cache
    if [[ -d "resources" ]]; then
        rm -rf resources
        echo "   ✅ Removed resources/ cache directory"
    fi

    # Remove any temp Hugo cache directories
    if [[ -n "${TMPDIR:-}" && -d "${TMPDIR}/hugo_cache" ]]; then
        rm -rf "${TMPDIR}/hugo_cache"
        echo "   ✅ Removed temporary Hugo cache"
    fi

    echo "✅ Clean complete!"

# Test GitHub Actions workflow locally using act
gh-act:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🎭 Running GitHub Actions locally with act..."

    # Check if act is installed
    if ! command -v act &> /dev/null; then
        echo "❌ act is not installed. Install it with:"
        echo "   curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | bash"
        echo "   Or: brew install act"
        exit 1
    fi

    echo "📋 Available jobs in workflow:"
    act -l
    echo ""
    echo "🚀 Running 'build' job..."
    act -j build

# Create a new writing post (requires title as argument)
new-writing TITLE:
    #!/usr/bin/env bash
    set -euo pipefail
    YEAR=$(date +%Y)
    SLUG=$(echo "{{ TITLE }}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    POST_PATH="content/writing/${SLUG}.md"

    echo "✍️  Creating new writing post: {{ TITLE }}"
    echo "📁 Path: ${POST_PATH}"

    hugo new content "${POST_PATH}"

    echo "✅ Post created! Edit it at: ${POST_PATH}"
    echo "💡 Run 'just serve --buildDrafts' to preview drafts"

# Create a new reading post (requires title as argument)
new-reading TITLE:
    #!/usr/bin/env bash
    set -euo pipefail
    YEAR=$(date +%Y)
    SLUG=$(echo "{{ TITLE }}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    POST_PATH="content/reading/${YEAR}/${SLUG}.md"

    echo "📚 Creating new reading post: {{ TITLE }}"
    echo "📁 Path: ${POST_PATH}"

    hugo new content "${POST_PATH}"

    echo "✅ Post created! Edit it at: ${POST_PATH}"
    echo "💡 Run 'just serve --buildDrafts' to preview drafts"

# Create a new cooking post (requires title as argument)
new-cooking TITLE:
    #!/usr/bin/env bash
    set -euo pipefail
    YEAR=$(date +%Y)
    SLUG=$(echo "{{ TITLE }}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    POST_PATH="content/cooking/${YEAR}/${SLUG}.md"

    echo "🍳 Creating new cooking post: {{ TITLE }}"
    echo "📁 Path: ${POST_PATH}"

    hugo new content "${POST_PATH}"

    echo "✅ Post created! Edit it at: ${POST_PATH}"
    echo "💡 Run 'just serve --buildDrafts' to preview drafts"

# Convert an image (jpg/jpeg/png) to webp for cooking posts
convert-cooking-image INPUT:
    #!/usr/bin/env bash
    set -euo pipefail

    if ! command -v cwebp &> /dev/null; then
        echo "❌ cwebp is not installed. Install it with:"
        echo "   brew install webp"
        exit 1
    fi

    INPUT="{{ INPUT }}"
    BASENAME=$(basename "${INPUT}" | sed 's/\.[^.]*$//')
    SLUG=$(echo "${BASENAME}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    OUTPUT="static/images/cooking/${SLUG}.webp"

    mkdir -p static/images/cooking

    echo "🖼️  Converting: ${INPUT}"
    echo "📁 Output: ${OUTPUT}"

    cwebp -q 80 -resize 1200 0 "${INPUT}" -o "${OUTPUT}"

    echo "✅ Converted! Use in frontmatter as: images/cooking/${SLUG}.webp"

# Update vendored PaperMod theme from upstream master
# (latest tag is stale; master has Hugo 0.146+ layout system)
update-theme:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🔄 Updating vendored PaperMod theme from upstream master..."

    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "${TMP_DIR}"' EXIT

    UPSTREAM="https://github.com/adityatelange/hugo-PaperMod.git"
    REF="${PAPERMOD_REF:-master}"
    COMMIT=$(git ls-remote "${UPSTREAM}" "refs/heads/${REF}" "refs/tags/${REF}" | awk 'NR==1 {print $1}')

    if [[ -z "${COMMIT}" ]]; then
        echo "❌ Could not resolve PaperMod ref: ${REF}"
        exit 1
    fi

    echo "📦 Upstream ${REF} @ ${COMMIT}"
    git clone --depth 1 --branch "${REF}" "${UPSTREAM}" "${TMP_DIR}/PaperMod"

    # Preserve only theme source; drop upstream git/CI metadata
    rm -rf themes/PaperMod
    mkdir -p themes/PaperMod
    rsync -a --exclude '.git' --exclude '.github' "${TMP_DIR}/PaperMod/" themes/PaperMod/
    printf '%s\n' "${COMMIT}" > themes/PaperMod/.vendor-revision
    printf '%s\n' "${REF}" > themes/PaperMod/.vendor-ref

    echo "✅ Theme updated to ${REF} (${COMMIT:0:7})"
    echo "💡 Review changes, test with 'just serve', then commit the vendored theme"

# Show repository status and useful info
status:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "📊 Landing Page Repository Status"
    echo "=================================="
    echo ""

    # Hugo version
    echo "🏗️  Hugo Version:"
    hugo version
    echo ""

    # Git status
    echo "📋 Git Status:"
    git status --porcelain || echo "   No changes"
    echo ""

    # Vendored theme status
    echo "📦 Theme Status:"
    if [[ -f "themes/PaperMod/theme.toml" ]]; then
        echo "   PaperMod vendored at themes/PaperMod"
        if command -v git &> /dev/null; then
            CHANGED=$(git status --porcelain themes/PaperMod | wc -l | tr -d ' ')
            echo "   Uncommitted theme file changes: ${CHANGED}"
        fi
    else
        echo "   ❌ themes/PaperMod missing"
    fi
    echo ""

    # Recent commits
    echo "📝 Recent Commits:"
    git log --oneline -5
    echo ""

    # Draft posts
    echo "✍️  Draft Posts:"
    find content -name "*.md" -exec grep -l "draft: true" {} \; 2>/dev/null | head -10 || echo "   No drafts found"
