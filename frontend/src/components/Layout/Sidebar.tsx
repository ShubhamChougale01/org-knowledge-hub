import { NavLink, useNavigate } from 'react-router-dom'
import { MessageSquare, Users, FolderKanban, Building2, GitBranch, LogOut } from 'lucide-react'
import { useAuthStore } from '@/store/auth'

const navItems = [
  { to: '/chat',      label: 'Chat',       icon: MessageSquare },
  { to: '/orgchart',  label: 'Org Chart',  icon: GitBranch },
  { to: '/employees', label: 'Employees',  icon: Users },
  { to: '/projects',  label: 'Projects',   icon: FolderKanban },
  { to: '/clients',   label: 'Clients',    icon: Building2 },
]

export default function Sidebar() {
  const navigate = useNavigate()
  const user = useAuthStore((s) => s.user)
  const logout = useAuthStore((s) => s.logout)

  const handleLogout = () => {
    logout()
    navigate('/login')
  }

  return (
    <aside className="w-64 bg-gradient-to-b from-brand-700 to-brand-900 text-white flex flex-col h-screen sticky top-0">
      <div className="p-6 border-b border-white/10">
        <h1 className="text-xl font-bold">🏢 Org Knowledge Hub</h1>
        <p className="text-xs text-white/70 mt-1">Coditas Internal</p>
      </div>

      <nav className="flex-1 p-4 space-y-1">
        {navItems.map(({ to, label, icon: Icon }) => (
          <NavLink
            key={to}
            to={to}
            className={({ isActive }) =>
              `flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors ${
                isActive
                  ? 'bg-white/20 text-white font-medium'
                  : 'text-white/80 hover:bg-white/10 hover:text-white'
              }`
            }
          >
            <Icon size={18} />
            <span>{label}</span>
          </NavLink>
        ))}
      </nav>

      <div className="p-4 border-t border-white/10">
        {user && (
          <div className="mb-3 text-sm">
            <div className="font-semibold">{user.full_name}</div>
            <div className="text-xs text-white/60">
              {user.access_level === 'L1' && 'Admin'}
              {user.access_level === 'L2' && 'Manager'}
              {user.access_level === 'L3' && 'Employee'}
              {user.access_level === 'L4' && 'System'}
            </div>
          </div>
        )}
        <button
          onClick={handleLogout}
          className="w-full flex items-center gap-2 px-3 py-2 text-sm text-white/80 hover:bg-white/10 rounded-lg transition-colors"
        >
          <LogOut size={16} />
          Logout
        </button>
      </div>
    </aside>
  )
}
