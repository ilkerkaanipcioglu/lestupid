# Mock server script to demonstrate what the project would look like when running
Write-Host "Starting Dukkadee mock server..." -ForegroundColor Green
Write-Host "Server running at http://localhost:4000" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available routes:" -ForegroundColor Yellow
Write-Host "  - http://localhost:4000/                   (Home page)" -ForegroundColor White
Write-Host "  - http://localhost:4000/stores/new         (Store creation flow)" -ForegroundColor White
Write-Host "  - http://localhost:4000/admin              (Admin dashboard)" -ForegroundColor White
Write-Host ""
Write-Host "Legacy Store Import Feature:" -ForegroundColor Yellow
Write-Host "  The Legacy Store Import feature allows users to migrate their existing e-commerce" -ForegroundColor White
Write-Host "  stores to Dukkadee with a single click. The system automatically scrapes the" -ForegroundColor White
Write-Host "  legacy store, extracts products, pages, and brand colors, and creates a modern," -ForegroundColor White
Write-Host "  better-looking store while preserving all the original content." -ForegroundColor White
Write-Host ""
Write-Host "Current UI Implementation:" -ForegroundColor Yellow
Write-Host "  - Input field for legacy store URL" -ForegroundColor White
Write-Host "  - Import button to initiate the process" -ForegroundColor White
Write-Host "  - Summary display showing:" -ForegroundColor White
Write-Host "    * Number of imported products" -ForegroundColor White
Write-Host "    * Number of imported pages" -ForegroundColor White
Write-Host "    * Number of imported forms" -ForegroundColor White
Write-Host "    * Detected brand colors" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Red

# Keep the script running until user presses Ctrl+C
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} finally {
    Write-Host "Server stopped" -ForegroundColor Yellow
}
