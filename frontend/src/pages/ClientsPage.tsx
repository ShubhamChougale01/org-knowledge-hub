import { useEffect, useState } from 'react'
import { Building2, Users, ChevronRight, Globe } from 'lucide-react'
import { listClients, getClient } from '@/services/api'
import type { ClientResponse, ClientDetail } from '@/types'

export default function ClientsPage() {
  const [clients, setClients] = useState<ClientResponse[]>([])
  const [selected, setSelected] = useState<ClientDetail | null>(null)
  const [loading, setLoading] = useState(true)
  const [loadingDetail, setLoadingDetail] = useState(false)

  useEffect(() => {
    load()
  }, [])

  const load = async () => {
    setLoading(true)
    try {
      const data = await listClients()
      setClients(data)
      // Auto-select first client
      if (data.length > 0) {
        await selectClient(data[0].client_id)
      }
    } finally {
      setLoading(false)
    }
  }

  const selectClient = async (clientId: string) => {
    setLoadingDetail(true)
    try {
      const detail = await getClient(clientId)
      setSelected(detail)
    } finally {
      setLoadingDetail(false)
    }
  }

  return (
    <div className="min-h-screen">
      <header className="bg-white border-b px-6 py-4 sticky top-0 z-10">
        <h1 className="text-2xl font-bold text-slate-800">Clients</h1>
        <p className="text-sm text-slate-500">
          {clients.length} clients · See every project and team member per client
        </p>
      </header>

      <div className="flex h-[calc(100vh-72px)]">
        {/* Client list */}
        <aside className="w-72 bg-white border-r overflow-y-auto">
          {loading ? (
            <div className="p-6 text-slate-500">Loading...</div>
          ) : (
            <ul>
              {clients.map((c) => (
                <li key={c.client_id}>
                  <button
                    onClick={() => selectClient(c.client_id)}
                    className={`w-full text-left p-4 border-b border-slate-100 hover:bg-slate-50 transition-colors ${
                      selected?.client_id === c.client_id ? 'bg-brand-50 border-l-4 border-l-brand-500' : ''
                    }`}
                  >
                    <div className="font-semibold text-slate-800 text-sm">{c.name}</div>
                    <div className="text-xs text-slate-500 mt-1 flex items-center gap-2">
                      <span>{c.industry}</span>
                      <span>·</span>
                      <span>{c.total_projects} project{c.total_projects !== 1 ? 's' : ''}</span>
                    </div>
                  </button>
                </li>
              ))}
            </ul>
          )}
        </aside>

        {/* Client detail */}
        <section className="flex-1 overflow-y-auto p-6">
          {!selected ? (
            <div className="text-slate-500">Select a client to see details</div>
          ) : loadingDetail ? (
            <div className="text-slate-500">Loading...</div>
          ) : (
            <ClientDetailView client={selected} />
          )}
        </section>
      </div>
    </div>
  )
}

function ClientDetailView({ client }: { client: ClientDetail }) {
  return (
    <div className="max-w-4xl">
      {/* Client header */}
      <div className="bg-gradient-to-r from-brand-500 to-brand-700 text-white rounded-xl p-6 mb-6">
        <div className="flex items-start justify-between">
          <div>
            <div className="flex items-center gap-2 mb-2">
              <Building2 size={28} />
              <h2 className="text-2xl font-bold">{client.name}</h2>
            </div>
            <div className="flex items-center gap-4 text-sm text-white/90">
              <span>{client.industry}</span>
              <span className="flex items-center gap-1">
                <Globe size={14} /> {client.country}
              </span>
            </div>
          </div>
          <div className="text-right">
            <div className="text-3xl font-bold">{client.total_projects}</div>
            <div className="text-xs text-white/80 uppercase tracking-wide">Projects</div>
            <div className="text-2xl font-semibold mt-2">{client.total_employees}</div>
            <div className="text-xs text-white/80 uppercase tracking-wide">Employees</div>
          </div>
        </div>
      </div>

      {/* Projects */}
      <h3 className="text-lg font-semibold text-slate-800 mb-4">Projects</h3>
      {client.projects.length === 0 ? (
        <div className="text-slate-500">No projects associated with this client.</div>
      ) : (
        <div className="space-y-4">
          {client.projects.map((proj) => (
            <ProjectCard key={proj.project_id} project={proj} />
          ))}
        </div>
      )}
    </div>
  )
}

function ProjectCard({ project }: { project: ClientDetail['projects'][0] }) {
  const [expanded, setExpanded] = useState(false)
  const visibleTeam = expanded ? project.team : project.team.slice(0, 5)

  const statusColor =
    project.status === 'Active'
      ? 'bg-green-100 text-green-800'
      : project.status === 'Completed'
      ? 'bg-slate-100 text-slate-700'
      : 'bg-yellow-100 text-yellow-800'

  return (
    <div className="bg-white border border-slate-200 rounded-lg p-5">
      <div className="flex items-start justify-between mb-3">
        <div>
          <h4 className="text-lg font-bold text-slate-800">{project.name}</h4>
          <div className="flex items-center gap-2 mt-1">
            <span className={`text-xs px-2 py-0.5 rounded ${statusColor}`}>
              {project.status}
            </span>
            <span className="text-xs text-slate-500 flex items-center gap-1">
              <Users size={12} /> {project.team_size} member{project.team_size !== 1 ? 's' : ''}
            </span>
          </div>
        </div>
      </div>

      {project.tech_stack.length > 0 && (
        <div className="flex flex-wrap gap-1.5 mb-4">
          {project.tech_stack.map((tech) => (
            <span
              key={tech}
              className="px-2 py-0.5 bg-brand-50 text-brand-700 text-xs rounded"
            >
              {tech}
            </span>
          ))}
        </div>
      )}

      {project.team.length > 0 && (
        <div>
          <div className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">
            Team Members
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-1.5">
            {visibleTeam.map((m) => (
              <div key={m.employee_id} className="flex items-center gap-2 text-sm">
                <div className="w-7 h-7 rounded-full bg-brand-100 text-brand-700 flex items-center justify-center text-xs font-semibold flex-shrink-0">
                  {m.full_name.split(' ').map((n) => n[0]).join('').slice(0, 2)}
                </div>
                <div className="min-w-0">
                  <div className="text-slate-800 truncate">{m.full_name}</div>
                  <div className="text-xs text-slate-500 truncate">
                    {m.role_in_project || m.designation}
                  </div>
                </div>
              </div>
            ))}
          </div>
          {project.team.length > 5 && (
            <button
              onClick={() => setExpanded(!expanded)}
              className="mt-3 text-sm text-brand-600 hover:underline flex items-center gap-1"
            >
              {expanded
                ? 'Show fewer'
                : `Show all ${project.team.length}`}
              <ChevronRight size={14} className={expanded ? 'rotate-90' : ''} />
            </button>
          )}
        </div>
      )}
    </div>
  )
}
