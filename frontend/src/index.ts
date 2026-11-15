import { definePlugin } from '@alinha/plugin-sdk'
import { __CLASS__Page } from './pages/__CLASS__Page'

/**
 * The plugin's frontend entry point. The shell reads this object and mounts
 * the routes and the menu — nothing to register by hand in the shell.
 *   area 'client'     → /org/:org/<path>
 *   area 'consultant' → /portfolio/:org/<path>
 * User-visible text (title, label) is in European Portuguese, plain language
 * (UI requirement in the technical report). Paths are in English.
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
