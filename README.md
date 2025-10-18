# AkroShopX — configuration et déploiement sécurisé

Ce dépôt contient la configuration de la page d'accueil (`index.json`) et des scripts pour valider et déployer votre thème Shopify.

Important : le workflow CI/CD est sensible (push sur Shopify). Activez-le seulement quand il est 100% stable.

## Ce que j'ai ajouté

- `.github/workflows/deploy-shopify.yml` : workflow GitHub Actions pour valider JSON, exécuter `shopify theme check`, créer un backup artifact, vérifier la syntaxe Liquid (naïf), s'authentifier et pousser le thème non publié.
- `scripts/validate-json.js` : validateur Node local.
- `scripts/deploy.ps1` : script PowerShell local pour validation + push (utilise Shopify CLI).
- `scripts/local-backup.ps1` : crée un zip du projet et le copie sur le Bureau et sur la première clé USB détectée.
- `scripts/rollback.ps1` : restaure un backup zip local (confirmation demandée).

## Activer le pipeline seulement lorsqu'il est stable

1. Testez toutes les étapes localement :

```powershell
node .\scripts\validate-json.js
```

2. Testez `shopify theme check` et le push localement avec un thème de développement non publié.

3. N'ajoutez les secrets GitHub que lorsque vous êtes sûr du comportement :

  - `SHOPIFY_SHOP` : e.g. `1cm3x9-sb.myshopify.com`
  - `SHOPIFY_ADMIN_API_ACCESS_TOKEN` : token Admin API (thèmes read/write)

4. Dans GitHub, activez le workflow (merge sur `main`) seulement après plusieurs runs de tests locaux.

## Backups et rollbacks (sécurisé)

Les scripts fournis permettent une sauvegarde locale (Desktop + clé USB) et une restauration.

Utilisation :

Créer un backup :

```powershell
.\scripts\local-backup.ps1 -OutName "akroshopx-backup.zip"
```

Ce script :
- génère un zip horodaté du projet,
- copie la zip sur le Bureau,
- tente de copier la zip sur la première clé USB détectée (si présente).

Rollback :

```powershell
.\scripts\rollback.ps1 -BackupZip "C:\path\to\theme-backup-YYYYMMDD_HHMMSS.zip"
```

Le script demande confirmation avant d'extraire et écraser les fichiers.

> Sécurité : vérifiez la présence de la clé USB avant d'exécuter le backup automatique. Ne stockez pas les tokens dans des fichiers non sécurisés.

## CI — Que fait le workflow maintenant ?

- Installe Node et Shopify CLI
- Exécute `shopify theme check` (si disponible)
- Valide tous les fichiers JSON via `jq`
- Crée un zip backup et l'upload comme artifact GitHub Actions
- Vérifie la syntaxe Liquid via un grep (contrôle simple)
- Authentifie Shopify CLI via secrets
- Exécute `shopify theme push --force --unpublished`

Si vous souhaitez :

- Ajouter `theme check` plus strict (`@shopify/theme-check`) → je peux l'ajouter au workflow.
- Activer la publication automatique (si désiré) → je peux ajouter une option `publish` qui nécessite une approbation manuelle.

---

Dites-moi si je dois :

- ajouter `@shopify/theme-check` au workflow,
- forcer un backup vers un emplacement réseau ou cloud (S3, Google Drive),
- ou modifier la stratégie pour ne pas utiliser `--force` et demander une approbation manuelle en PR.
