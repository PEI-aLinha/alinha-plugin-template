import { definePlugin } from '@alinha/plugin-sdk'
import { __CLASS__Page } from './pages/__CLASS__Page'

/**
 * The plugin's frontend entry point. The shell reads this object and mounts
 * the routes and the menu — nothing to register by hand in the shell.
 *   area 'client'     → /org/:org/<path>
 *   area 'consultant' → /carteira/<path>
 * User-visible text (title, label) and paths are in Portuguese, plain language
 * (UI requirement in the technical report).
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
