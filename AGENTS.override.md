# AGENTS.override.md — Easybooru Deploy-Hinweise

Dieses Repository läuft auf dem privaten Easybooru-Server unter:

- Pfad: `/opt/danbooru`
- Domain: `https://easy69.de`
- Docker Compose Projekt: Danbooru / Easybooru
- Standard-Deploy-Ziel: `master`

## Wichtig

Easybooru nutzt aktuell einen Overlay-Build statt eines vollständigen Danbooru-Docker-Builds.

Grund: Der vollständige Docker-Build von Danbooru kann an Ubuntu-Snapshot-Paketquellen scheitern. Für kleine UI-/Template-Änderungen ist das Overlay schneller und stabiler.

Der normale Danbooru-Compose-Stack nutzt das Image aus `.env`:

```env
DANBOORU_IMAGE=...
