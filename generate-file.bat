@echo off
setlocal

:: ==========================================
:: AI-SDD Project Structure Generator
:: ==========================================

echo Creating AI-SDD project structure...

:: Root folders
mkdir docs
mkdir docs\diagrams
mkdir features
mkdir src

:: Create root files
type nul > readme.md
type nul > agents.md

:: Create docs files
type nul > docs\context.md
type nul > docs\architecture.md
type nul > docs\api_spec.yaml
type nul > docs\done.md

:: Create Mermaid diagram placeholders
type nul > docs\diagrams\data-model.md
type nul > docs\diagrams\components.md
type nul > docs\diagrams\sequence-auth.md
type nul > docs\diagrams\sequence-admin-noauth.md

:: Create sample feature placeholders
type nul > docs\features\_feature-template.md

:: Optional .gitkeep files (for empty folders)
type nul > src\.gitkeep

echo.
echo ==========================================
echo AI-SDD structure created successfully!
echo ==========================================
echo.
echo Generated:
echo   readme.md
echo   agents.md
echo   docs\
echo   src\
echo.
pause