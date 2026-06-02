// Shared types matching backend Pydantic models

export type AccessLevel = 'L1' | 'L2' | 'L3' | 'L4'

export interface User {
  user_id: string
  full_name: string
  access_level: AccessLevel
}

export interface TokenResponse {
  access_token: string
  token_type: string
  expires_in: number
  user_id: string
  full_name: string
  access_level: AccessLevel
}

export interface ChatRequest {
  query: string
  session_id?: string
}

export interface ChatResponse {
  answer: string
  cypher_used: string
  execution_ms: number
  trace_url?: string
  from_cache: boolean
  row_count: number
  success: boolean
  error?: string
}

export interface EmployeeResponse {
  employee_id: string
  full_name: string
  email: string
  department?: string
  role?: string
  joining_date?: string
  current_status?: string
}

export interface EmployeeSkill {
  name: string
  category?: string
  proficiency: string
  years?: number
}

export interface EmployeeCertification {
  name: string
  issuer?: string
  issued_date?: string
  expiry_date?: string
}

export interface EmployeeProject {
  name: string
  role_in_project?: string
  is_current: boolean
  start_date?: string
  end_date?: string
}

export interface EmployeePromotion {
  from_role: string
  to_role: string
  effective_date: string
}

export interface EmployeeDetail extends EmployeeResponse {
  total_experience_years?: number
  org_experience_years?: number
  gender?: string
  phone?: string
  dob?: string
  address?: string
  reports_to?: string
  skills: EmployeeSkill[]
  certifications: EmployeeCertification[]
  projects: EmployeeProject[]
  promotions: EmployeePromotion[]
}

export interface ProjectResponse {
  project_id: string
  name: string
  type?: string
  status?: string
  client_name?: string
  team_size: number
}

export interface ProjectTeamMember {
  employee_id: string
  full_name: string
  role_in_project?: string
  designation?: string
}

export interface ProjectDetail extends ProjectResponse {
  description?: string
  start_date?: string
  end_date?: string
  tech_stack: string[]
  manager?: string
  team: ProjectTeamMember[]
}

export interface ClientResponse {
  client_id: string
  name: string
  industry?: string
  country?: string
  total_projects: number
  total_active_projects: number
}

export interface ProjectWithTeam {
  project_id: string
  name: string
  status?: string
  tech_stack: string[]
  team_size: number
  team: ProjectTeamMember[]
}

export interface ClientDetail {
  client_id: string
  name: string
  industry?: string
  country?: string
  total_projects: number
  total_employees: number
  projects: ProjectWithTeam[]
}
