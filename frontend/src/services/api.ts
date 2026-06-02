import axios, { AxiosError } from 'axios'
import { useAuthStore } from '@/store/auth'
import type {
  TokenResponse,
  ChatRequest,
  ChatResponse,
  EmployeeResponse,
  EmployeeDetail,
  ProjectResponse,
  ProjectDetail,
  ClientResponse,
  ClientDetail,
} from '@/types'

// Call backend directly (CORS is allowed for localhost:3000)
// This bypasses the Vite proxy entirely so config caching issues don't break login.
const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:8001'

const api = axios.create({
  baseURL: API_BASE,
  timeout: 30_000,
})

// Attach JWT to every request
api.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Auto-logout on 401
api.interceptors.response.use(
  (r) => r,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      useAuthStore.getState().logout()
      if (window.location.pathname !== '/login') {
        window.location.href = '/login'
      }
    }
    return Promise.reject(error)
  },
)

// ─── Auth ─────────────────────────────────────────────────────────────
export const login = async (email: string, password: string): Promise<TokenResponse> => {
  const { data } = await api.post<TokenResponse>('/auth/login', { email, password })
  return data
}

// ─── Chat ─────────────────────────────────────────────────────────────
export const sendChatMessage = async (request: ChatRequest): Promise<ChatResponse> => {
  const { data } = await api.post<ChatResponse>('/chat', request)
  return data
}

// ─── Employees ────────────────────────────────────────────────────────
export const listEmployees = async (filters?: {
  department?: string
  project?: string
  skill?: string
  skip?: number
  limit?: number
}): Promise<EmployeeResponse[]> => {
  const { data } = await api.get<EmployeeResponse[]>('/employees', { params: filters })
  return data
}

export const getEmployee = async (employeeId: string): Promise<EmployeeDetail> => {
  const { data } = await api.get<EmployeeDetail>(`/employees/${employeeId}`)
  return data
}

export const getReportingChain = async (employeeId: string) => {
  const { data } = await api.get<{ chain: string[]; levels: number }>(
    `/employees/${employeeId}/reporting-chain`,
  )
  return data
}

// ─── Projects ─────────────────────────────────────────────────────────
export const listProjects = async (status?: string): Promise<ProjectResponse[]> => {
  const { data } = await api.get<ProjectResponse[]>('/projects', { params: { status } })
  return data
}

export const getProject = async (projectId: string): Promise<ProjectDetail> => {
  const { data } = await api.get<ProjectDetail>(`/projects/${projectId}`)
  return data
}

// ─── Clients ──────────────────────────────────────────────────────────
export const listClients = async (): Promise<ClientResponse[]> => {
  const { data } = await api.get<ClientResponse[]>('/clients')
  return data
}

export const getClient = async (clientId: string): Promise<ClientDetail> => {
  const { data } = await api.get<ClientDetail>(`/clients/${clientId}`)
  return data
}

// ─── Health ───────────────────────────────────────────────────────────
export const checkHealth = async () => {
  const { data } = await api.get('/health')
  return data
}

export default api
