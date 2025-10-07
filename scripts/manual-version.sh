#!/bin/bash

# Manual version management script
# Use this only when automated versioning is not sufficient

set -e

CHART_FILE="charts/supabase/Chart.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to get current version
get_current_version() {
    grep '^version:' "$CHART_FILE" | awk '{print $2}'
}

# Function to update version in Chart.yaml
update_version() {
    local new_version=$1
    sed -i.bak "s/^version: .*/version: $new_version/" "$CHART_FILE"
    rm -f "${CHART_FILE}.bak"
    print_success "Updated version to $new_version in $CHART_FILE"
}

# Function to create git tag
create_tag() {
    local version=$1
    if git tag -l | grep -q "^v$version$"; then
        print_warning "Tag v$version already exists"
        return 1
    fi

    git tag "v$version"
    print_success "Created git tag v$version"
}

# Function to show current version
show_version() {
    local version=$(get_current_version)
    print_info "Current version: $version"
}

# Function to bump version
bump_version() {
    local bump_type=$1
    local current_version=$(get_current_version)
    local major minor patch

    IFS='.' read -r major minor patch <<< "$current_version"

    case $bump_type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            print_error "Invalid bump type: $bump_type"
            print_info "Valid types: major, minor, patch"
            exit 1
            ;;
    esac

    local new_version="$major.$minor.$patch"
    update_version "$new_version"
    print_success "Bumped version from $current_version to $new_version"
}

# Function to set specific version
set_version() {
    local new_version=$1

    # Validate version format
    if [[ ! $new_version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format: $new_version"
        print_info "Version must be in format: MAJOR.MINOR.PATCH"
        exit 1
    fi

    update_version "$new_version"
    print_success "Set version to $new_version"
}

# Function to create tag for current version
tag_version() {
    local version=$(get_current_version)
    create_tag "$version"
}

# Main script logic
case "${1:-show}" in
    show)
        show_version
        ;;
    major|minor|patch)
        bump_version "$1"
        ;;
    set)
        if [ -z "$2" ]; then
            print_error "Version number required"
            print_info "Usage: $0 set <version>"
            exit 1
        fi
        set_version "$2"
        ;;
    tag)
        tag_version
        ;;
    help|--help|-h)
        echo "Manual Version Management Script"
        echo ""
        echo "Usage: $0 [COMMAND] [VERSION]"
        echo ""
        echo "Commands:"
        echo "  show                    Show current version"
        echo "  major                   Bump major version (x.0.0)"
        echo "  minor                   Bump minor version (0.x.0)"
        echo "  patch                   Bump patch version (0.0.x)"
        echo "  set <version>           Set specific version"
        echo "  tag                     Create git tag for current version"
        echo "  help                    Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 show                 # Show current version"
        echo "  $0 patch                # Bump patch version"
        echo "  $0 minor                # Bump minor version"
        echo "  $0 major                # Bump major version"
        echo "  $0 set 1.2.3            # Set version to 1.2.3"
        echo "  $0 tag                  # Create git tag"
        echo ""
        echo "Note: This script is for manual versioning only."
        echo "The project uses automated versioning based on conventional commits."
        ;;
    *)
        print_error "Unknown command: $1"
        print_info "Run '$0 help' for usage information"
        exit 1
        ;;
esac