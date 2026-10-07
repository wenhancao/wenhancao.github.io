param(
    [string]$BuildDirectory = (Join-Path ([System.IO.Path]::GetTempPath()) "wenhancao-documents")
)

$ErrorActionPreference = "Stop"
$dataDirectory = $PSScriptRoot
$buildRoot = [System.IO.Path]::GetFullPath($BuildDirectory)

function Invoke-Checked {
    param([string]$Command, [string[]]$Arguments)
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Command failed with exit code $LASTEXITCODE" }
}

function Build-Cv {
    param([string]$Compiler, [string]$Main, [string]$Output)
    $directory = Join-Path $buildRoot "cv"
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    Copy-Item -Path (Join-Path $dataDirectory "cv/*.tex") -Destination $directory
    Push-Location $directory
    try {
        foreach ($pass in 1..2) {
            Invoke-Checked $Compiler @("-interaction=nonstopmode", "-halt-on-error", $Main)
        }
        Copy-Item -LiteralPath ([System.IO.Path]::ChangeExtension($Main, ".pdf")) -Destination (Join-Path $dataDirectory $Output)
    } finally { Pop-Location }
}

Build-Cv "pdflatex" "main.tex" "CV.pdf"
Build-Cv "xelatex" "main-zh.tex" "CV_zh.pdf"

$directory = Join-Path $buildRoot "publications"
New-Item -ItemType Directory -Force -Path $directory | Out-Null
Copy-Item -Path (Join-Path $dataDirectory "publications/*.tex"), (Join-Path $dataDirectory "publications/*.bib") -Destination $directory
Push-Location $directory
try {
    Invoke-Checked "pdflatex" @("-interaction=nonstopmode", "-halt-on-error", "main.tex")
    Invoke-Checked "biber" @("main")
    foreach ($pass in 1..2) {
        Invoke-Checked "pdflatex" @("-interaction=nonstopmode", "-halt-on-error", "main.tex")
    }
    Copy-Item -LiteralPath "main.pdf" -Destination (Join-Path $dataDirectory "Publication_list_by_type.pdf")
} finally { Pop-Location }
