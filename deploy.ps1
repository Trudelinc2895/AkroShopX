# Déploiement Shopify via Shopify CLI
# Ce script suppose que vous avez installé et connecté la Shopify CLI (`shopify login --store your-store.myshopify.com`).
# Il pousse le thème courant vers le store configuré.

param(
  [string]$ThemeName = "AkroShopX-theme",
  [switch]$Publish
)

# Validation JSON
Write-Host "Validation de index.json..."
try {
  Get-Content -Raw -Path (Join-Path $PSScriptRoot '..\index.json') | ConvertFrom-Json | Out-Null
  Write-Host "index.json : OK"
} catch {
  Write-Error "index.json invalide. Abandon du déploiement."
  exit 1
}

# Build / autres étapes ici si nécessaire

# Pousser le thème via Shopify CLI
Write-Host "Lancement du déploiement via Shopify CLI..."
if ($Publish) {
  shopify theme push --unpublished --theme-name $ThemeName --publish
} else {
  shopify theme push --unpublished --theme-name $ThemeName
}

if ($LASTEXITCODE -ne 0) {
  Write-Error "La commande shopify a échoué. Vérifiez votre connexion et vos droits."
  exit $LASTEXITCODE
}

Write-Host "Déploiement terminé."
