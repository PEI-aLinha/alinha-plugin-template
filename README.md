# __NAME__

<!-- TEMPLATE:START -->
> **This is the aLinha plugin template.** Plugins are not created by hand:
> in the main repo run `./scripts/new-plugin.sh <feature|provider> <id> "<Name>"`,
> which creates the repo from here, runs `scripts/init-plugin.sh` and adds it as a submodule.

<!-- TEMPLATE:END -->
**__KIND__** plugin of [aLinha](https://github.com/PEI-aLinha/alinha). It lives in the main repo as a
submodule at `plugins/__KIND__/__ID__` and is built together with the core into a single deployable.

```
backend/    Kotlin — Spring Modulith module pt.alinha.__PKG__
  api/        «api» contract (the only synchronous access for other plugins)
  events/     published events
  internal/   everything else — private
  resources/db/migration/__PKG__/   Flyway migrations (schema __PKG__)
frontend/   React — @alinha/plugin-__ID__ (routes + menu, read by the shell)
worker/     Python — collector (providers only)
plugin.yaml manifest
```

## Development

This repo **does not build on its own**. Work inside a checkout of the main repo:

```bash
git clone --recurse-submodules git@github.com:PEI-aLinha/alinha.git
cd alinha/plugins/__KIND__/__ID__
git switch -c feat/<topic>
# ... code ...
git push -u origin feat/<topic>      # PR in this repo
```

Run the tests (from the main repo root):

```bash
./gradlew :__ID__:test :app:test              # plugin tests + module verification
pnpm --filter @alinha/plugin-__ID__ typecheck
```

## Rules

- Code, comments and commits in English; user-visible UI text in Portuguese.
- Backend: only use `pt.alinha.pluginapi`, the core's named interfaces (`core.tenant`, `core.access`,
  `core.audit`, `core.jobs`, `core.compliance`, `core.aigateway`) and other plugins' `api`/`events`.
- Frontend: only import `@alinha/plugin-sdk`, `@alinha/ui`, `@alinha/api-client`.
- Migrations: `V<yyyyMMddHHmmss>__<description>.sql` (the timestamp avoids collisions between plugins).
- Keep `plugin.yaml` and `*Plugin.kt` in sync (published/consumed events, permissions).

## Definition of Done

- [ ] Endpoints have `@RequiresPermission`
- [ ] Writes go to the Audit Trail in the same transaction
- [ ] Queries are filtered by `TenantContext`
- [ ] Tests pass and CI is green (including the main repo's `ModularityTest`)
