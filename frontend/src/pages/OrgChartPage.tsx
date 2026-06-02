import { useEffect, useState, useMemo } from 'react'
import ReactFlow, { Background, Controls, MiniMap, Node, Edge, MarkerType } from 'reactflow'
import 'reactflow/dist/style.css'
import { listEmployees, getEmployee } from '@/services/api'
import type { EmployeeResponse, EmployeeDetail } from '@/types'
import { X } from 'lucide-react'

const DEPT_COLORS: Record<string, string> = {
  Tech:       '#3b82f6',
  Delivery:   '#10b981',
  Sales:      '#f59e0b',
  Marketing:  '#ec4899',
  HR:         '#8b5cf6',
  Finance:    '#ef4444',
  Executive:  '#1f2937',
}

export default function OrgChartPage() {
  const [employees, setEmployees] = useState<EmployeeResponse[]>([])
  const [reportingMap, setReportingMap] = useState<Record<string, string>>({})
  const [loading, setLoading] = useState(true)
  const [selected, setSelected] = useState<EmployeeDetail | null>(null)
  const [loadingDetail, setLoadingDetail] = useState(false)

  useEffect(() => {
    loadOrg()
  }, [])

  const loadOrg = async () => {
    setLoading(true)
    try {
      const emps = await listEmployees({ limit: 100 })
      setEmployees(emps)
      // Fetch reporting links - simple approach: query reports for each top-level role
      // For PoC, we just show the org tree based on what's available
    } finally {
      setLoading(false)
    }
  }

  const { nodes, edges } = useMemo(() => buildGraph(employees, reportingMap), [
    employees,
    reportingMap,
  ])

  const handleNodeClick = async (_: any, node: Node) => {
    setLoadingDetail(true)
    try {
      const detail = await getEmployee(node.id)
      setSelected(detail)
    } catch {
      // ignore
    } finally {
      setLoadingDetail(false)
    }
  }

  return (
    <div className="h-screen flex flex-col">
      <header className="bg-white border-b px-6 py-4 sticky top-0 z-10">
        <h1 className="text-2xl font-bold text-slate-800">Organization Chart</h1>
        <p className="text-sm text-slate-500">
          Click any employee to see their full profile · {employees.length} employees total
        </p>
      </header>

      <div className="flex-1 relative">
        {loading ? (
          <div className="absolute inset-0 flex items-center justify-center text-slate-500">
            Loading org chart...
          </div>
        ) : (
          <ReactFlow
            nodes={nodes}
            edges={edges}
            onNodeClick={handleNodeClick}
            fitView
            attributionPosition="bottom-left"
          >
            <Background />
            <Controls />
            <MiniMap nodeColor={(n) => (n.data as any).color || '#999'} />
          </ReactFlow>
        )}

        {selected && (
          <EmployeeDetailPanel
            employee={selected}
            loading={loadingDetail}
            onClose={() => setSelected(null)}
          />
        )}
      </div>
    </div>
  )
}

// ─── Build nodes and edges by department + role level ─────────────────
function buildGraph(employees: EmployeeResponse[], _reportingMap: Record<string, string>) {
  const nodes: Node[] = []
  const edges: Edge[] = []

  // Group by department for clearer layout
  const byDept = new Map<string, EmployeeResponse[]>()
  employees.forEach((e) => {
    const dept = e.department || 'Unassigned'
    if (!byDept.has(dept)) byDept.set(dept, [])
    byDept.get(dept)!.push(e)
  })

  const deptOrder = ['Executive', 'Tech', 'Delivery', 'Sales', 'Marketing', 'HR', 'Finance']
  let xOffset = 0

  deptOrder.forEach((deptName) => {
    const emps = byDept.get(deptName) || []
    if (emps.length === 0) return

    // Add a department label node
    nodes.push({
      id: `dept-${deptName}`,
      data: { label: deptName, color: DEPT_COLORS[deptName] || '#999' },
      position: { x: xOffset, y: 0 },
      style: {
        background: DEPT_COLORS[deptName] || '#999',
        color: 'white',
        border: 'none',
        borderRadius: 8,
        padding: 10,
        fontWeight: 600,
        width: 180,
      },
    })

    emps.slice(0, 10).forEach((emp, idx) => {
      nodes.push({
        id: emp.employee_id,
        data: {
          label: (
            <div className="text-center">
              <div className="font-semibold text-xs">{emp.full_name}</div>
              <div className="text-[10px] opacity-80">{emp.role || ''}</div>
            </div>
          ),
          color: DEPT_COLORS[deptName] || '#999',
        },
        position: { x: xOffset, y: 100 + idx * 70 },
        style: {
          background: 'white',
          border: `2px solid ${DEPT_COLORS[deptName] || '#999'}`,
          borderRadius: 8,
          padding: 8,
          width: 180,
          cursor: 'pointer',
        },
      })

      edges.push({
        id: `e-dept-${deptName}-${emp.employee_id}`,
        source: `dept-${deptName}`,
        target: emp.employee_id,
        style: { stroke: DEPT_COLORS[deptName] || '#999', strokeWidth: 1.5 },
        markerEnd: { type: MarkerType.ArrowClosed, color: DEPT_COLORS[deptName] || '#999' },
      })
    })

    xOffset += 240
  })

  return { nodes, edges }
}

// ─── Side panel ───────────────────────────────────────────────────────
function EmployeeDetailPanel({
  employee,
  loading,
  onClose,
}: {
  employee: EmployeeDetail
  loading: boolean
  onClose: () => void
}) {
  return (
    <div className="absolute top-0 right-0 h-full w-96 bg-white border-l shadow-xl overflow-y-auto z-20 p-6">
      <div className="flex justify-between items-start mb-4">
        <div>
          <h2 className="text-xl font-bold text-slate-800">{employee.full_name}</h2>
          <p className="text-sm text-slate-500">{employee.employee_id}</p>
        </div>
        <button onClick={onClose} className="text-slate-500 hover:text-slate-800">
          <X size={20} />
        </button>
      </div>

      {loading ? (
        <div className="text-slate-500">Loading...</div>
      ) : (
        <div className="space-y-4 text-sm">
          <Field label="Role" value={employee.role} />
          <Field label="Department" value={employee.department} />
          <Field label="Email" value={employee.email} />
          <Field label="Joined" value={employee.joining_date} />
          <Field label="Org Experience" value={employee.org_experience_years && `${employee.org_experience_years} years`} />
          <Field label="Total Experience" value={employee.total_experience_years && `${employee.total_experience_years} years`} />
          <Field label="Reports To" value={employee.reports_to} />

          {employee.skills.length > 0 && (
            <Section title="Skills">
              <div className="flex flex-wrap gap-1.5">
                {employee.skills.map((s, i) => (
                  <span
                    key={i}
                    className={`px-2 py-0.5 text-xs rounded ${
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
              <ul className="space-y-1">
                {employee.certifications.map((c, i) => (
                  <li key={i} className="text-xs text-slate-700">
                    🏆 {c.name} <span className="text-slate-400">({c.issued_date})</span>
                  </li>
                ))}
              </ul>
            </Section>
          )}

          {employee.projects.length > 0 && (
            <Section title="Projects">
              <ul className="space-y-1">
                {employee.projects.map((p, i) => (
                  <li key={i} className="text-xs text-slate-700">
                    {p.is_current ? '🟢' : '⚪'} {p.name}
                    {p.role_in_project && (
                      <span className="text-slate-400"> · {p.role_in_project}</span>
                    )}
                  </li>
                ))}
              </ul>
            </Section>
          )}

          {employee.promotions.length > 0 && (
            <Section title="Promotion History">
              <ul className="space-y-1">
                {employee.promotions.map((p, i) => (
                  <li key={i} className="text-xs text-slate-700">
                    {p.effective_date}: {p.from_role} → {p.to_role}
                  </li>
                ))}
              </ul>
            </Section>
          )}
        </div>
      )}
    </div>
  )
}

function Field({ label, value }: { label: string; value?: string | number | null }) {
  if (!value) return null
  return (
    <div>
      <div className="text-xs text-slate-500">{label}</div>
      <div className="text-slate-800">{value}</div>
    </div>
  )
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="pt-3 border-t border-slate-100">
      <div className="text-xs font-semibold text-slate-500 mb-2">{title.toUpperCase()}</div>
      {children}
    </div>
  )
}
