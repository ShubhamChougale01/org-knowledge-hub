import { Routes, Route, Navigate } from 'react-router-dom'
import LoginPage from '@/pages/LoginPage'
import ChatPage from '@/pages/ChatPage'
import OrgChartPage from '@/pages/OrgChartPage'
import EmployeesPage from '@/pages/EmployeesPage'
import ProjectsPage from '@/pages/ProjectsPage'
import ClientsPage from '@/pages/ClientsPage'
import AppLayout from '@/components/Layout/AppLayout'

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route element={<AppLayout />}>
        <Route path="/chat"      element={<ChatPage />} />
        <Route path="/orgchart"  element={<OrgChartPage />} />
        <Route path="/employees" element={<EmployeesPage />} />
        <Route path="/projects"  element={<ProjectsPage />} />
        <Route path="/clients"   element={<ClientsPage />} />
      </Route>
      <Route path="*" element={<Navigate to="/chat" replace />} />
    </Routes>
  )
}
