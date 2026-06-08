# Phoenix Interactive Start Script
$phoenixCommand = "-S mix phx.server"

if (Test-Path "$env:ProgramFiles\Elixir\bin\iex.bat") {
    & "$env:ProgramFiles\Elixir\bin\iex.bat" $phoenixCommand
} else {
    Write-Host "Elixir not found in default location!" -ForegroundColor Red
    Write-Host "Try running from Elixir's installed bin directory"
}
