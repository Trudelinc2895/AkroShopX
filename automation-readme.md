# AkroShopX — Automatisation des mises à jour produits

Ce pack complète le dépôt **AkroShopX** avec des scripts et un workflow GitHub Actions destinés à automatiser l'extraction, la mise à jour et l'importation des produits dans votre boutique Shopify.

## Contenu du pack

- `update-products.py` – script Python qui:
  1. Exécute `pipeline.py` (déjà fourni) pour extraire ~100 produits par catégorie depuis AliExpress et Wish et générer un CSV compatible Shopify.
  2. Lit le CSV généré et crée ou met à jour chaque produit via l'API Shopify (`POST /admin/api/2025-01/products.json`).
  
  Le script s'appuie sur deux variables d'environnement à fournir dans le contexte d'exécution ou via des secrets GitHub :
  - `SHOPIFY_SHOP` : domaine de la boutique Shopify (ex. `akroshopx.myshopify.com`).
  - `SHOPIFY_ADMIN_API_ACCESS_TOKEN` : token API Admin avec droits d'écriture sur les produits.

- `.github/workflows/update-products.yml` – fichier Workflow GitHub Actions planifié :
  - S'exécute tous les jours à 06h00 UTC (02h00 heure de l'Est).
  - Installe Python, les dépendances et lance `update-products.py`.
  - Paramètre `max_per_category` et `languages` configurable via les entrées du workflow.

## Installation manuelle dans votre dépôt

1. **Copiez** `update-products.py` à la racine de votre dépôt GitHub `AkroShopX`.
2. **Créez** le dossier `.github/workflows/` s'il n'existe pas et placez `update-products.yml` à l'intérieur.
3. **Ajoutez** ou mettez à jour le fichier `requirements.txt` pour inclure les dépendances nécessaires au script (requests, playwright, pandas, etc.).
4. **Créez** des secrets GitHub `SHOPIFY_SHOP` et `SHOPIFY_ADMIN_API_ACCESS_TOKEN` dans les paramètres de votre dépôt.
5. **Activez** le workflow GitHub Actions en le fusionnant sur la branche `main`.
6. Vérifiez que `pipeline.py` se trouve à la racine du dépôt et fonctionne correctement.

## Remarques importantes

- Le script `update-products.py` crée les produits sans vérifier les doublons. Pour un usage en production, envisagez d'ajouter une logique de recherche par SKU et de mise à jour des produits existants.
- DSers/AutoDS doit être configuré séparément pour mapper les SKU aux fournisseurs et automatiser les commandes.
- Si vous changez l'heure d'exécution du cron, ajustez le champ `cron` dans `.github/workflows/update-products.yml` en conséquence (horaires en UTC).
