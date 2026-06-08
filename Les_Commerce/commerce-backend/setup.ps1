# Setup script for Dukkadee.com project
Write-Host "Setting up Dukkadee.com project..." -ForegroundColor Green

# Step 1: Install Elixir
Write-Host "Step 1: Installing Elixir..." -ForegroundColor Cyan
Write-Host "Please download and install Elixir from: https://elixir-lang.org/install.html#windows"
Write-Host "After installation, close and reopen your PowerShell window, then run this script again."
Write-Host "If Elixir is already installed, the script will continue."

# Check if Elixir is installed
$elixirInstalled = $false
try {
    $elixirVersion = elixir --version
    $elixirInstalled = $true
    Write-Host "Elixir is installed: $elixirVersion" -ForegroundColor Green
}
catch {
    Write-Host "Elixir is not installed or not in PATH." -ForegroundColor Yellow
    exit
}

# Step 2: Install Phoenix
if ($elixirInstalled) {
    Write-Host "Step 2: Installing Phoenix Framework..." -ForegroundColor Cyan
    mix local.hex --force
    mix archive.install hex phx_new 1.7.7 --force
    
    # Step 3: Install dependencies
    Write-Host "Step 3: Installing project dependencies..." -ForegroundColor Cyan
    mix deps.get
    
    # Step 4: Create and migrate database
    Write-Host "Step 4: Setting up database..." -ForegroundColor Cyan
    mix ecto.create
    mix ecto.migrate
    
    # Step 5: Install Node.js dependencies
    Write-Host "Step 5: Installing Node.js dependencies..." -ForegroundColor Cyan
    cd assets
    npm install
    cd ..
    
    # Step 6: Start the Phoenix server
    Write-Host "Step 6: Starting Phoenix server..." -ForegroundColor Cyan
    Write-Host "Run 'mix phx.server' to start the development server."
    Write-Host "Then visit http://localhost:4000 in your browser."
    
    Write-Host "Setup complete!" -ForegroundColor Green
}
