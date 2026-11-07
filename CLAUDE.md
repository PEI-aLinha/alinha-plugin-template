# CLAUDE.md — __NAME__ plugin (__KIND__)

This is a **git submodule** of the aLinha main repo, mounted at `plugins/__KIND__/__ID__`.
The main repo's `CLAUDE.md` (two levels up) has the global rules. This file covers only what is specific to this repo.

## Where you are

- This directory is its own repo (`git remote get-url origin` shows which one).
  `git` commands run here act on **this plugin**. The root repo only holds a pointer to a commit of it.
- **It does not build on its own.** It needs `plugin-api`, `plugin-sdk`, `ui` and `api-client` from the main repo.
  Run every build or test from the main repo root:
  ```bash
  cd "$(git rev-parse --show-superproject-working-tree)"
  ./gradlew :__ID__:test :app:test                  # plugin tests + ModularityTest
  pnpm gen:plugins && pnpm --filter @alinha/plugin-__ID__ typecheck && pnpm lint
  ```
  If `--show-superproject-working-tree` prints nothing, the repo was cloned standalone. Tell the user to clone the
  main repo with `--recurse-submodules` instead.
- The checkout is usually on a **detached HEAD**. Before the first commit, run `git switch -c feat/<topic>` (or
  `git switch main`), then push and open the PR **in this repo**. Never update the pointer in the main repo from
  here.

## Layout

```
backend/src/main/kotlin/pt/alinha/__PKG__/
  __CLASS__Plugin.kt   the single AlinhaPlugin bean; manifest must match plugin.yaml
  api/                 «api» named interface — the ONLY synchronous entry point for other plugins
  events/              «events» named interface — DomainEvents this plugin publishes
  internal/            everything else (web controllers, services, JPA entities, repositories) — private
backend/src/main/resources/db/migration/__PKG__/   Flyway, schema "__PKG__"
frontend/src/index.ts      definePlugin({ id: '__ID__', routes, nav }) — read by the shell
frontend/src/pages/        React pages
worker/                    Python collector (providers only), installed into the worker runtime
plugin.yaml                manifest: id, kind, version, path, publishes, consumes, permissions
```

## Rules for this plugin

- New public types go in `api/` or `events/`. Everything else goes in `internal/`. Never import another plugin's
  `internal` or the core's non-named packages. If you need data from another plugin, use its `api/` or react to
  its events.
- When you add events or permissions, update **both** `plugin.yaml` and `__CLASS__Plugin.kt` in the same commit.
- Migrations: `V<yyyyMMddHHmmss>__<pkg>_<description>.sql` (here `<pkg>` = `__PKG__`), only inside the `__PKG__`
  schema. Never edit a migration that has been merged.
- Every endpoint needs `@RequiresPermission`. Get the tenant from `TenantContext` (never from the request) and
  filter every query by it. Call `AuditTrail.record(...)` for every write, in the same transaction.
- Frontend: import only `@alinha/plugin-sdk`, `@alinha/ui` and `@alinha/api-client`. Use `useHost()` for the
  session, permissions and `api`. Labels, titles and **route paths** in European Portuguese. Code and comments in
  English.
- Providers: collectors are **read-only** and treat collected data as untrusted. Job payloads follow
  `contracts/jobs/*.schema.json` in the main repo. If a contract has to change, stop and follow the main repo's
  "Changing `plugin-api` or `contracts/`" procedure.

## Definition of Done

- [ ] Endpoints have `@RequiresPermission`
- [ ] Writes go to the Audit Trail in the same transaction
- [ ] Queries are filtered by `TenantContext`
- [ ] `./gradlew :__ID__:test :app:test` green (ModularityTest included), frontend typecheck + lint green
