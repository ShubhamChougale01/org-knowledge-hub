import { useEffect, useState } from 'react'
import { Search, X, Mail, Calendar, Building } from 'lucide-react'
import { listEmployees, getEmployee } from '@/services/api'
import type { EmployeeResponse, EmployeeDetail } from '@/types'

const DEPARTMENTS = ['Tech', 'Delivery', 'Sales', 'Marketing', 'HR', 'Finance', 'Executive']

export default function EmployeesPage() {
  const [employees, setEmployees] = useState<EmployeeResponse[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [department, setDepartment] = useState<string>('')
  const [selected, setSelected] = useState<EmployeeDetail | null>(null)

  useEffect(() => {
    load()
  }, [department])

  const load = async () => {
    setLoading(true)
    try {
      const data = await listEmployees({
        department: department || undefined,
        limit: 100,
      })
      setEmployees(data)
    } finally {
      setLoading(false)
    }
  }

  const filtered = employees.filter((e) =>
    e.full_name.toLowerCase().includes(search.toLowerCase()),
  )

  const openProfile = async (id: string) => {
    try {
      const detail = await getEmployee(id)
      setSelected(detail)
    } catch (err) {
      console.error(err)
    }
  }

  return (
    <div className="min-h-screen">
      <header className="bg-white border-b px-6 py-4 sticky top-0 z-10">
        <h1 className="text-2xl font-bold text-slate-800">Employees</h1>
        <p className="text-sm text-slate-500">
          Browse {filtered.length} of {employees.length} employees
        </p>
      </header>

      <div className="p-6">
        {/* Filters */}
        <div className="flex flex-wrap gap-3 mb-6">
          <div className="relative flex-1 min-w-[200px]">
            <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              placeholder="Search by name..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full pl-9 pr-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 outline-none"
            />
          </div>

          <select
            value={department}
            onChange={(e) => setDepartment(e.target.value)}
            className="px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 outline-none bg-white"
          >
            <option value="">All Departments</option>
            {DEPARTMENTS.map((d) => (
              <option key={d} value={d}>
                {d}
              </option>
            ))}
          </select>
        </div>

        {/* Grid */}
        {loading ? (
          <div className="text-slate-500">Loading...</div>
        ) : filtered.length === 0 ? (
          <div className="text-slate-500 text-center py-12">No employees match your filters.</div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
            {filtered.map((emp) => (
              <button
                key={emp.employee_id}
                onClick={() => openProfile(emp.employee_id)}
                className="text-left bg-white border border-slate-200 rounded-lg p-4 hover:shadow-md hover:border-brand-500 transition-all"
              >
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-10 h-10 rounded-full bg-brand-100 text-brand-700 flex items-center justify-center font-semibold">
                    {emp.full_name.split(' ').map((n) => n[0]).join('').slice(0, 2)}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="font-semibold text-sm text-slate-800 truncate">
                      {emp.full_name}
                    </div>
                    <div className="text-xs text-slate-500 truncate">{emp.role || '—'}</div>
                  </div>
                </div>
                <div className="text-xs text-slate-600 space-y-1">
                  <div className="flex items-center gap-1.5">
                    <Building size={12} /> {emp.department || '—'}
                  </div>
                  <div className="flex items-center gap-1.5 truncate">
                    <Mail size={12} /> <span className="truncate">{emp.email}</span>
                  </div>
                  {emp.joining_date && (
                    <div className="flex items-center gap-1.5">
                      <Calendar size={12} /> Joined {emp.joining_date}
                    </div>
                  )}
                </div>
              </button>
            ))}
          </div>
        )}
      </div>

      {selected && <EmployeeModal employee={selected} onClose={() => setSelected(null)} />}
    </div>
  )
}

function EmployeeModal({
  employee,
  onClose,
}: {
  employee: EmployeeDetail
  onClose: () => void
}) {
  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div className="bg-gradient-to-r from-brand-500 to-brand-700 text-white p-6 sticky top-0">
          <div className="flex justify-between items-start">
            <div>
              <h2 className="text-2xl font-bold">{employee.full_name}</h2>
              <p className="text-sm text-white/80">{employee.role} · {employee.department}</p>
              <p className="text-xs text-white/70 mt-1">{employee.employee_id}</p>
            </div>
            <button onClick={onClose} className="text-white/80 hover:text-white">
              <X size={20} />
            </button>
          </div>
        </div>

        <div className="p-6 space-y-5">
          <div className="grid grid-cols-2 gap-4 text-sm">
            <Info label="Email" value={employee.email} />
            <Info label="Status" value={employee.current_status} />
            <Info label="Joined" value={employee.joining_date} />
            <Info
              label="Org Experience"
              value={employee.org_experience_years && `${employee.org_experience_years} years`}
            />
            <Info label="Reports To" value={employee.reports_to} />
            <Info
              label="Total Experience"
              value={employee.total_experience_years && `${employee.total_experience_years} years`}
            />
            {employee.phone && <Info label="Phone" value={employee.phone} />}
            {employee.dob && <Info label="DOB" value={employee.dob} />}
            {employee.address && <Info label="Address" value={employee.address} />}
          </div>

          {employee.skills.length > 0 && (
            <Section title="Skills">
              <div className="flex flex-wrap gap-1.5">
                {employee.skills.map((s, i) => (
                  <span
                    key={i}
                    className={`px-2.5 py-1 text-xs rounded ${
                      s.proficiency === 'expert'
                        ? 'bg-green-100 text-green-800'
                        : s.proficiency === 'intermediate'
                        ? 'bg-blue-100 text-blue-800'
                        : 'bg-slate-100 text-slate-700'
                    }`}
                  >
                    {s.name} · {s.proficiency}
                  </span>
                ))}
              </div>
            </Section>
          )}

          {employee.certifications.length > 0 && (
            <Section title="Certifications">
              <ul className="space-y-1.5">
                {employee.certifications.map((c, i) => (
                  <li key={i} className="text-sm">
                    🏆 <strong>{c.name}</strong>
                    {c.issuer && <span className="text-slate-500"> · {c.issuer}</span>}
                    {c.issued_date && <span className="text-slate-400 text-xs ml-1">({c.issued_date})</span>}
                  </li>
                ))}
              </ul>
            </Section>
          )}

          {employee.projects.length > 0 && (
            <Section title="Projects">
              <ul className="space-y-1.5">
                {employee.projects.map((p, i) => (
                  <li key={i} className="text-sm">
                    {p.is_current ? '🟢' : '⚪'} <strong>{p.name}</strong>
                    {p.role_in_project && (
                      <span className="text-slate-500"> · {p.role_in_project}</span>
                    )}
                  </li>
                ))}
              </ul>
            </Section>
          )}

          {employee.promotions.length > 0 && (
            <Section title="Promotion History">
              <ul className="space-y-1.5">
                {employee.promotions.map((p, i) => (
                  <li key={i} className="text-sm">
                    <span className="text-slate-500">{p.effective_date}</span>:{' '}
                    {p.from_role} → <strong>{p.to_role}</strong>
                  </li>
                ))}
              </ul>
            </Section>
          )}
        </div>
      </div>
    </div>
  )
}

function Info({ label, value }: { label: string; value?: string | number | null }) {
  if (!value) return null
  return (
    <div>
      <div className="text-xs text-slate-500">{label}</div>
      <div className="text-slate-800 font-medium">{value}</div>
    </div>
  )
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <h3 className="text-sm font-semibold text-slate-500 uppercase tracking-wide mb-2">
        {title}
      </h3>
      {children}
    </div>
  )
}
