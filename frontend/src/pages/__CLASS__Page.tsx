import { useQuery } from '@tanstack/react-query'
import { useHost } from '@alinha/plugin-sdk'
import { PageHeader } from '@alinha/ui'

export function __CLASS__Page() {
  const { api } = useHost()
  const ping = useQuery({
    queryKey: ['__ID__', 'ping'],
    queryFn: () => api<{ plugin: string; status: string }>('/__ID__/ping'),
  })

  return (
    <>
      <PageHeader title="__NAME__" />
      <p>Backend: {ping.isPending ? 'a verificar…' : ping.isError ? 'indisponível' : ping.data.status}</p>
    </>
  )
}
