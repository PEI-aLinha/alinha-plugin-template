import { definePlugin } from '@alinha/plugin-sdk'
import { __CLASS__Page } from './pages/__CLASS__Page'

/**
 * Ponto de entrada do plugin no frontend. O shell lê este objeto e monta
 * as rotas e o menu — não há nada a registar à mão no shell.
 *   area 'client'     → /org/:org/<path>
 *   area 'consultant' → /carteira/<path>
 */
export default definePlugin({
  id: '__ID__',
  name: '__NAME__',
  routes: {
    client: [
      { path: '__ID__', handle: { title: '__NAME__' }, Component: __CLASS__Page },
    ],
  },
  nav: [
    { label: '__NAME__', path: '__ID__', area: 'client' },
  ],
})
