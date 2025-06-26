<#
.SYNOPSIS
Prepares the project by renaming files, cleaning up unnecessary files and removing itself.

#>

$newName = $args[0]

# 1. Run rename.ps1 with "newName" argument
if (Test-Path ".\rename.ps1") {
    Write-Host "Running rename.ps1 with newName=$newName argument..."
    & ".\rename.ps1" $newName
}

# 2. Replace path to current
## Путь к JSON-файлу
$jsonPath = "./appsettings.local.json"
## Получаем текущую директорию и экранируем обратные слэши
$newPath = (Get-Location).Path -replace '\\', '/'

## Добавим завершающий слэш, если нужно
if (-not $newPath.EndsWith('\\')) {
    $newPath += '/'
}
## Читаем файл
$content = Get-Content $jsonPath -Raw

## Заменяем значение "Path": "..."
$content = $content -replace '("Path"\s*:\s*")([^"]*)(")', "`$1$newPath`$3"

## Сохраняем обратно
Set-Content -Path $jsonPath -Value $content -Encoding UTF8

# 3. Delete specified files and directories
$itemsToDelete = @(
    "LICENSE.txt",
    "README.md",
    "rename.ps1",
    ".git"
)

foreach ($item in $itemsToDelete) {
    if (Test-Path $item) {
        try {
            if (Test-Path $item -PathType Container) {
                Write-Host "Removing directory: $item"
                Remove-Item $item -Recurse -Force -ErrorAction Stop
            }
            else {
                Write-Host "Removing file: $item"
                Remove-Item $item -Force -ErrorAction Stop
            }
        }
        catch {
            Write-Warning "Failed to remove $item : $_"
        }
    }
}

# 4. Delete itself
Write-Host "Removing prepare.ps1..."
Start-Sleep -Seconds 1  # Small delay to ensure script completes
Remove-Item $MyInvocation.MyCommand.Path -Force