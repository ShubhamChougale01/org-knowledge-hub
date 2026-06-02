import { useEffect, useState } from 'react'
import { FolderKanban, Users, X } from 'lucide-react'
import { listProjects, getProject } from '@/services/api'
import type { ProjectResponse, ProjectDetail } from '@/types'

export default function ProjectsPage() {
  const [projects, setProjects] = useState<ProjectResponse[]>([])
  const [status, setStatus] = useState<string>('')
  const [loading, setLoading] = useState(true)
  const [selected, setSelected] = useState<ProjectDetail | null>(null)

  useEffect(() => {
    load()
  }, [status])

  const load = async () => {
    setLoading(true)
    try {
      const data = await listProjects(status || undefined)
      setProjects(data)
    } finally {
      setLoading(false)
    }
  }

  const openProject = async (id: string) => {
    try {
      const detail = await getProject(id)
      setSelected(detail)
    } catch (err) {
      console.error(err)
    }
  }

  const statusColor = (s?: string) =>
    s === 'Active'
      ? 'bg-green-100 text-green-800'
      : s === 'Completed'
      ? 'bg-slate-100 text-slate-700'
      : s === 'On-hold'
      ? 'bg-yellow-100 text-yellow-800'
      : 'bg-slate-100 text-slate-700'

  return (
    <div className="min-h-screen">
      <header className="bg-white border-b px-6 py-4 sticky top-0 z-10">
        <h1 className="text-2xl font-bold text-slate-800">Projects</h1>
        <p className="text-sm text-slate-500">{projects.length} projects</p>
      </header>

      <div className="p-6">
        <div className="flex gap-2 mb-6">
          {['', 'Active', 'Completed', 'On-hold'].map((s) => (
            <button
              key={s || 'all'}
              onClick={() => setStatus(s)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                status === s
                  ? 'bg-brand-600 text-white'
                  : 'bg-white border border-slate-300 text-slate-700 hover:bg-slate-50'
              }`}
            >
              {s || 'All'}
            </button>
          ))}
        </div>

        {loading ? (
          <div className="text-slate-500">Loading...</div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {projects.map((p) => (
              <button
                key={p.project_id}
                onClick={() => openProject(p.project_id)}
                className="text-left bg-white border border-slate-200 rounded-lg p-5 hover:shadow-md hover:border-brand-500 transition-all"
              >
                <div className="flex items-start justify-between mb-2">
                  <FolderKanban size={20} className="text-brand-600" />
                  <span className={`text-xs px-2 py-0.5 rounded ${statusColor(p.status)}`}>
                    {p.status}
                  </span>
                </div>
                <h3 className="font-bold text-slate-800 mb-1">{p.name}</h3>
                <div className="text-xs text-slate-500 space-y-1">
                  <div>{p.type === 'Client' ? `Client: ${p.client_name}` : 'Internal'}</div>
                  <div className="flex items-center gap-1">
                    <Users size={12} /> {p.team_size} members
                  </div>
                </div>
              </button>
            ))}
          </div>
        )}
      </div>

      {selected && <ProjectModal project={selected} onClose={() => setSelected(null)} />}
    </div>
  )
}

function ProjectModal({ project, onClose }: { project: ProjectDetail; onClose: () => void }) {
  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <div className="bg-gradient-to-r from-brand-500 to-brand-700 text-white p-6">
          <div className="flex justify-between items-start">
            <div>
              <h2 className="text-2xl font-bold">{project.name}</h2>
              <p className="text-sm text-white/80 mt-1">
                {project.type} · {project.status}
                {project.client_name && ` · ${project.client_name}`}
              </p>
            </div>
            <button onClick={onClose} className="text-white/80 hover:text-white">
              <X size={20} />
            </button>
          </div>
        </div>

        <div className="p-6 space-y-5">
          {project.description && (
            <div>
              <div className="text-xs font-semibold text-slate-500 uppercase mb-1">About</div>
              <p className="text-sm text-slate-700">{project.description}</p>
            </div>
          )}

          <div className="grid grid-cols-2 gap-4 text-sm">
            {project.start_date && (
              <div>
                <div className="text-xs text-slate-500">Started</div>
                <div className="font-medium">{project.start_date}</div>
              </div>
            )}
            {project.end_date && (
              <div>
                <div className="text-xs text-slate-500">Ended</div>
                <div className="font-medium">{project.end_date}</div>
              </div>
            )}
            {project.manager && (
              <div>
                <div className="text-xs text-slate-500">Manager</div>
                <div className="font-medium">{project.manager}</div>
              </div>
            )}
            <div>
              <div className="text-xs text-slate-500">Team Size</div>
              <div className="font-medium">{project.team_size}</div>
            </div>
          </div>

          {project.tech_stack.length > 0 && (
            <div>
              <div className="text-xs font-semibold text-slate-500 uppercase mb-2">Tech Stack</div>
              <div className="flex flex-wrap gap-1.5">
                {project.tech_stack.map((t) => (
                  <span key={t} className="px-2 py-0.5 bg-brand-50 text-brand-700 text-xs rounded">
                    {t}
                  </span>
                ))}
              </div>
            </div>
          )}

          {project.team.length > 0 && (
            <div>
              <div className="text-xs font-semibold text-slate-500 uppercase mb-2">
                Team Members
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                {project.team.map((m) => (
                  <div key={m.employee_id} className="flex items-center gap-2 text-sm">
                    <div className="w-8 h-8 rounded-full bg-brand-100 text-brand-700 flex items-center justify-center text-xs font-semibold">
                      {m.full_name.split(' ').map((n) => n[0]).join('').slice(0, 2)}
                    </div>
                    <div>
                      <div className="text-slate-800">{m.full_name}</div>
                      <div className="text-xs text-slate-500">{m.role_in_project || m.designation}</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
