\
# Add or remove global npm packages here
$packages = @(
    "npm-check-updates",
    "typescript",
    "ts-node",
    "eslint",
    "nodemon"
    "tree-sitter-cli
)

# Ensure npm is available
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Error "npm is not available. Make sure Node.js is installed and restart your shell."
    exit 1
}

foreach ($pkg in $packages) {
    Write-Host "Installing npm package: $pkg"
    npm install -g $pkg
}
