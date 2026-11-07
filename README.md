# __NAME__

<!-- TEMPLATE:START -->
> **Este é o template dos plugins da aLinha.** Não se cria um plugin à mão:
> no repo principal corre `./scripts/new-plugin.sh <feature|provider> <id> "<Nome>"`,
> que cria o repo a partir daqui, corre `scripts/init-plugin.sh` e liga-o como submodule.

<!-- TEMPLATE:END -->
Plugin **__KIND__** da [aLinha](https://github.com/PEI-aLinha/alinha). Vive no repo principal como
submodule em `plugins/__KIND__/__ID__` e é compilado junto com o Core num único deployable.

```
backend/    Kotlin — módulo Spring Modulith pt.alinha.__PKG__
  api/        contrato «api» (único acesso síncrono de outros plugins)
  events/     eventos publicados
  internal/   tudo o resto — privado
  resources/db/migration/__PKG__/   migrações Flyway (schema __PKG__)
frontend/   React — @alinha/plugin-__ID__ (rotas + menu, lidos pelo shell)
worker/     Python — collector (só em providers)
plugin.yaml manifest
```

## Desenvolver

Este repo **não compila sozinho**. Trabalha-se dentro do checkout do repo principal:

```bash
git clone --recurse-submodules git@github.com:PEI-aLinha/alinha.git
cd alinha/plugins/__KIND__/__ID__
git switch -c feat/<tema>
# ... código ...
git push -u origin feat/<tema>      # PR neste repo
```

Correr testes (a partir da raiz do repo principal):

```bash
./gradlew :__ID__:test :app:test              # testes do plugin + verificação de módulos
pnpm --filter @alinha/plugin-__ID__ typecheck
```

## Regras

- Backend: só usar `pt.alinha.pluginapi`, as named interfaces do Core (`core.tenant`, `core.access`,
  `core.audit`, `core.jobs`, `core.compliance`, `core.aigateway`) e o `api`/`events` de outros plugins.
- Frontend: só importar `@alinha/plugin-sdk`, `@alinha/ui`, `@alinha/api-client`.
- Migrações: `V<yyyyMMddHHmmss>__<descricao>.sql` (timestamp evita colisões entre plugins).
- Manter `plugin.yaml` e `*Plugin.kt` iguais (eventos publicados/consumidos, permissões).

## Definition of Done

- [ ] Endpoints com `@RequiresPermission`
- [ ] Escritas com Audit Trail na mesma transação
- [ ] Queries filtradas pelo `TenantContext`
- [ ] Testes a passar e CI verde (inclui `ModularityTest` do repo principal)
