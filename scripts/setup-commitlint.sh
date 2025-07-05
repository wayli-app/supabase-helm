#!/bin/bash

# Setup script for pre-commit hooks
# This script installs pre-commit and configures git hooks

set -e

echo "🔧 Setting up pre-commit hooks..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    echo "Please install Python 3 from https://python.org/"
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required but not installed."
    echo "Please install pip3 or use a Python installer that includes pip."
    exit 1
fi

echo "✅ Python 3 and pip3 are available"

# Install pre-commit
echo "📦 Installing pre-commit..."
pip3 install pre-commit

# Install the git hook scripts
echo "🔗 Installing git hooks..."
pre-commit install

# Install commit-msg hook for conventional commits
echo "📝 Installing commit-msg hook..."
pre-commit install --hook-type commit-msg

# Update pre-commit hooks
echo "🔄 Updating pre-commit hooks..."
pre-commit autoupdate

echo "✅ Setup complete!"
echo ""
echo "🎉 Pre-commit hooks are now active!"
echo ""
echo "📝 Your commits will now be validated automatically:"
echo "   - Conventional commit message format"
echo "   - YAML syntax validation"
echo "   - Helm chart linting"
echo "   - Markdown formatting"
echo "   - Shell script linting"
echo "   - Secret detection"
echo "   - Spell checking"
echo ""
echo "📚 For commit message guidelines, see:"
echo "   - docs/COMMIT_MESSAGES.md"
echo "   - https://www.conventionalcommits.org/"
echo ""
echo "🔍 To test your setup, try:"
echo "   pre-commit run --all-files"
echo ""
echo "💡 Remember to use conventional commit format:"
echo "   git commit -m 'type(scope): description'"
echo ""
echo "🛠️  To run hooks manually:"
echo "   pre-commit run"
echo "   pre-commit run --all-files"