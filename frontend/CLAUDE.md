# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the Org Knowledge Hub frontend.

---

## 1. Frontend Stack & Key Dependencies

**Core Framework:**
- **React 18.3.1** — UI library with hooks
- **TypeScript 5.6.3** — Static type checking
- **Vite 5.4.10** — Lightning-fast build tool + dev server

**Routing & Navigation:**
- **React Router 6.27.0** — Client-side routing; uses `<Routes>`, `<Route>`, `<NavLink>`

**Styling:**
- **Tailwind CSS 3.4.14** — Utility-first CSS framework
- **PostCSS 8.4.47** — Processes Tailwind
- **Autoprefixer 10.4.20** — Adds vendor prefixes

**State Management:**
- **Zustand 5.0.0** — Lightweight state store; used for auth state only

**HTTP Client:**
- **Axios 1.7.7** — Promise-based HTTP client; configured with JWT interceptors

**Icons:**
- **Lucide-react 0.460.0** — Free, lightweight icon library; 450+ icons available

**Graph Visualization:**
- **React Flow 11.11.4** — Interactive node/edge graph (used in OrgChartPage)

**Dev Tools:**
- **@vitejs/plugin-react 4.3.3** — Fast Refresh for React
- **@types/react 18.3.12, @types/react-dom 18.3.1** — Type definitions
- **@types/node 25.9.1** — Node.js types (for path resolution in Vite)

**No UI component library** — All components built from scratch with Tailwind; lucide-react is the only external component dependency.

---

## 2. How to Run the Frontend Locally

### Prerequisites
- Node.js 18+ (tested on 18.x, 20.x)
- Backend running at `http://localhost:8001`
- Neo4j + databases running (see parent CLAUDE.md for setup)

### Installation & Development

```bash
# Install dependencies
npm install

# Start dev server on http://localhost:3000
npm run dev

# In another terminal, start backend (from ../backend/)
cd ../backend
uvicorn main:app --reload --port 8001
```

The dev server includes:
- **Hot Module Replacement (HMR)** — auto-refresh on file save
- **Fast Refresh** — preserves state across edits
- **Request proxy** — `/api` calls route to `http://localhost:8001`

### Building for Production

```bash
# Type-check + bundle
npm run build

# Output goes to dist/
# Ready to deploy (static SPA)

# Optional: preview production build locally
npm run preview
# Opens at http://localhost:4173
```

**Build process:**
1. `tsc -b` — TypeScript type-check (strict mode)
2. `vite build` — Minify, chunk, optimize
3. Output: `dist/index.html` + bundled JS/CSS

---

## 3. Folder Structure & What Each Folder Does

```
frontend/
├── src/
│   ├── main.tsx              # Entry point; sets up React Router + renders App
│   ├── App.tsx               # Route definitions; all 5 pages + login
│   ├── index.css             # Global styles + Tailwind imports
│   │
│   ├── pages/                # Full-page components (route handlers)
│   │   ├── LoginPage.tsx     # Email/password auth form; sets token + user in store
│   │   ├── ChatPage.tsx      # Main chat interface; message history + input
│   │   ├── OrgChartPage.tsx  # React Flow org visualization + employee detail panel
│   │   ├── EmployeesPage.tsx # Employee grid + modal; search + department filter
│   │   ├── ProjectsPage.tsx  # Project grid + modal; status filter
│   │   └── ClientsPage.tsx   # Client sidebar + detail view; auto-expands projects
│   │
│   ├── components/           # Reusable/layout components
│   │   └── Layout/
│   │       ├── AppLayout.tsx # Protected layout; sidebar + outlet for page content
│   │       └── Sidebar.tsx   # Navigation menu + user profile + logout
│   │
│   ├── services/             # API client
│   │   └── api.ts            # Axios instance + all API methods (auth, chat, CRUD)
│   │
│   ├── store/                # Global state (Zustand)
│   │   └── auth.ts           # Token + user info; localStorage persisted
│   │
│   └── types/                # TypeScript type definitions
│       └── index.ts          # Mirrors backend Pydantic models (exact field names)
│
├── index.html                # HTML entry point; `<div id="root"></div>`
├── vite.config.ts            # Vite config; path aliases, dev server, proxy
├── tsconfig.json             # TypeScript config; ES2020 target, strict mode
├── tailwind.config.js        # Tailwind theme; custom brand colors
├── postcss.config.js         # PostCSS plugins (tailwindcss, autoprefixer)
├── package.json              # Dependencies + scripts
└── package-lock.json         # Locked dependency versions
```

### Key Files Explained

**src/main.tsx** — Renders React app with Router wrapper:
```tsx
<BrowserRouter>
  <App />
</BrowserRouter>
```

**src/App.tsx** — Defines 6 routes:
- `/login` — LoginPage (not protected)
- `/chat`, `/orgchart`, `/employees`, `/projects`, `/clients` — wrapped in AppLayout (protected)
- `*` — redirects to `/chat`

**src/pages/*** — Full-page components; each manages its own local state and API calls:
- Fetch data on mount (`useEffect`)
- Display loading/error states
- Render modals or side panels for detail views
- No inter-page communication (each page is independent)

**src/services/api.ts** — Axios client:
- Base URL: `http://localhost:8001` (or `VITE_API_URL` env var)
- Auto-attaches JWT token to every request
- Auto-logs out on 401 and redirects to `/login`
- Exports async functions: `login()`, `sendChatMessage()`, `listEmployees()`, etc.

**src/store/auth.ts** — Zustand store:
- Persists token + user to localStorage (key: `okh-auth`)
- Survives page refresh
- Single source of truth for auth state

**src/types/index.ts** — Type definitions matching backend:
- `TokenResponse` — login response
- `ChatResponse` — chat answer + metadata
- `EmployeeResponse`, `EmployeeDetail` — employee list + full profile
- `ProjectResponse`, `ProjectDetail`, `ClientResponse`, `ClientDetail`
- All field names must match backend JSON exactly (snake_case)

---

## 4. Component Conventions

### Naming
- **Pages** (`src/pages/*.tsx`): `PascalCase`, e.g., `ChatPage`, `OrgChartPage`
- **Components** (`src/components/**/*.tsx`): `PascalCase`, e.g., `Sidebar`, `AppLayout`
- **Utils/Helpers**: Not yet used; if needed, use `camelCase`, e.g., `formatDate.ts`
- **Files**: Match the component name exactly, e.g., `Sidebar.tsx` contains `export default function Sidebar() {}`

### Structure Pattern (Full-Page Components)

Every page follows this structure:

```tsx
export default function PageName() {
  // 1. State hooks
  const [data, setData] = useState<DataType[]>([])
  const [loading, setLoading] = useState(true)
  const [selected, setSelected] = useState<DetailType | null>(null)

  // 2. Effect hooks (fetch data on mount)
  useEffect(() => {
    loadData()
  }, [])

  // 3. Event handlers
  const loadData = async () => {
    setLoading(true)
    try {
      const result = await apiMethod()
      setData(result)
    } catch (err) {
      // Handle error (usually just log, show toast, or message)
    } finally {
      setLoading(false)
    }
  }

  // 4. JSX
  return (
    <div>
      <header>Title + subtitle</header>
      {loading ? <div>Loading...</div> : <MainContent />}
      {selected && <DetailModal onClose={() => setSelected(null)} />}
    </div>
  )
}

// 5. Sub-components (defined below main component)
function DetailModal({ ... }) { ... }
function ListItem({ ... }) { ... }
```

### Styling Conventions

**Always use Tailwind utility classes; never write CSS files** (except global `index.css`).

Common patterns:
- **Containers**: `flex`, `flex-col`, `gap-X`, `p-X`, `max-w-X`
- **Responsive**: `sm:`, `md:`, `lg:`, `xl:` prefixes; grid adapts with `grid-cols-1 md:grid-cols-2 lg:grid-cols-3`
- **Colors**: Use `brand-*` custom colors (`brand-500`, `brand-600`, `brand-700`, `brand-900`); system colors for status (green-*, red-*, yellow-*)
- **Interactive**: `hover:shadow-md`, `hover:border-brand-500`, `transition-all`, `disabled:opacity-50`, `cursor-pointer`
- **Typography**: `text-sm`, `font-semibold`, `text-slate-800`, `text-slate-500` (for labels)

**Spacing scale:**
```
px/py-1/2/3/4/5/6 → 4px/8px/12px/16px/20px/24px
gap-1/2/3/4 → same
```

### State Management

**Auth state** — Use Zustand:
```tsx
import { useAuthStore } from '@/store/auth'

const token = useAuthStore((s) => s.token)
const { setAuth, logout } = useAuthStore()
```

**Page-level data** — Use `useState`:
```tsx
const [employees, setEmployees] = useState<EmployeeResponse[]>([])
const [loading, setLoading] = useState(true)
```

**No Redux, Context, or prop drilling.** If a state needs to be shared across pages, add it to `src/store/auth.ts` and export a new hook.

### Error Handling

Keep it simple — log errors but don't block the UI:
```tsx
try {
  const result = await apiCall()
  setData(result)
} catch (err: any) {
  // Option 1: Log to console
  console.error(err)

  // Option 2: Show error message in UI (e.g., toast or inline text)
  setError(err.response?.data?.detail || 'Something went wrong')

  // Option 3: Don't re-throw; let the page gracefully degrade
} finally {
  setLoading(false)
}
```

**401 errors** are handled globally in `src/services/api.ts` — auto-logout and redirect.

---

## 5. How Frontend Connects to Backend

### API Base URL

Set via environment variable (highest priority to lowest):

1. **`VITE_API_URL`** environment variable
   ```bash
   VITE_API_URL=https://api.example.com npm run dev
   ```

2. **`.env` file** (not committed; optional)
   ```
   VITE_API_URL=http://localhost:8001
   ```

3. **Default** (hardcoded in `src/services/api.ts`)
   ```tsx
   const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:8001'
   ```

### Axios Configuration

**src/services/api.ts** sets up the client:

```tsx
const api = axios.create({
  baseURL: API_BASE,
  timeout: 30_000,  // 30-second timeout
})

// 1. Request interceptor: Attach JWT token
api.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 2. Response interceptor: Auto-logout on 401
api.interceptors.response.use(
  (r) => r,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      useAuthStore.getState().logout()
      window.location.href = '/login'
    }
    return Promise.reject(error)
  },
)
```

### API Call Pattern

All API methods follow this shape:

```tsx
// Typing: matches backend Pydantic response
export const sendChatMessage = async (request: ChatRequest): Promise<ChatResponse> => {
  const { data } = await api.post<ChatResponse>('/chat', request)
  return data
}

// Usage in component:
try {
  const response = await sendChatMessage({ query: 'Who works on NeuraVault?' })
  setMessages(prev => [...prev, { role: 'bot', text: response.answer }])
} catch (err) {
  // Handle error
}
```

### Endpoints Consumed

All routes below assume `http://localhost:8001/`:

| Method | Endpoint | Frontend Function | Returns |
|--------|----------|-------------------|---------|
| `POST` | `/auth/login` | `login(email, password)` | `TokenResponse` |
| `POST` | `/chat` | `sendChatMessage(query, session_id)` | `ChatResponse` |
| `GET` | `/employees` | `listEmployees(filters)` | `EmployeeResponse[]` |
| `GET` | `/employees/{id}` | `getEmployee(id)` | `EmployeeDetail` |
| `GET` | `/employees/{id}/reporting-chain` | `getReportingChain(id)` | `{ chain, levels }` |
| `GET` | `/projects` | `listProjects(status)` | `ProjectResponse[]` |
| `GET` | `/projects/{id}` | `getProject(id)` | `ProjectDetail` |
| `GET` | `/clients` | `listClients()` | `ClientResponse[]` |
| `GET` | `/clients/{id}` | `getClient(id)` | `ClientDetail` |
| `GET` | `/health` | `checkHealth()` | `{ status: 'ok' }` |

### Type Definitions Must Match Backend

Every type in `src/types/index.ts` mirrors a backend Pydantic model. Field names are **case-sensitive and must be snake_case** (e.g., `full_name`, `employee_id`, `access_level`).

If backend changes a response schema, update `src/types/index.ts` immediately — TypeScript will catch mismatches at compile-time.

---

## 6. Build & Deployment Commands

### Development

```bash
npm run dev
```

- Starts Vite dev server on `http://localhost:3000`
- Watches all files for changes (Hot Module Replacement)
- Proxies `/api` calls to `http://localhost:8001`

### Type-Check Only

```bash
tsc --noEmit
```

Validates TypeScript without emitting files (useful in CI/git hooks).

### Production Build

```bash
npm run build
```

**What it does:**
1. Runs `tsc -b` — full TypeScript check
2. If errors, stops (does not build)
3. Runs `vite build` — bundles and minifies
4. Output: `dist/index.html`, `dist/assets/index-*.js`, `dist/assets/index-*.css`

**Output is production-ready:**
- All code is minified
- No source maps (unless configured)
- Ready to deploy to any static host

### Preview Production Build

```bash
npm run preview
```

Runs the `dist/` output locally on `http://localhost:4173` — useful to verify production build works before deploying.

### Deployment

The `dist/` folder is a **static SPA** (Single Page Application). Deploy it to:

- **Vercel** (Recommended) — Zero-config, auto-deploys on push
- **Netlify** — Drag & drop or CI integration
- **AWS S3 + CloudFront** — Manual CDN setup
- **Docker** — Serve `dist/` with Nginx/Apache
- **Any web server** — Just copy `dist/` contents

**Important:** Configure your host to redirect all routes to `index.html` (SPA routing requirement). Vercel/Netlify do this automatically.

### Environment Variables in Build

Vite loads `.env` files at build time. To use environment variables in production:

```bash
# Development
VITE_API_URL=http://localhost:8001 npm run dev

# Production build
VITE_API_URL=https://api.production.com npm run build

# Preview the production build
npm run preview
```

**Note:** Environment variables are bundled at build time (not runtime). If you need to change the API URL after deployment, you must rebuild.

---

## Development Checklist

Before committing or deploying:

- [ ] `npm run build` succeeds (no TS errors)
- [ ] `npm run dev` starts without errors
- [ ] All pages load and navigate correctly
- [ ] Login works with test creds (`shubham.chougale@coditas.com` / `coditas2026`)
- [ ] Chat page can send a message and receive a response
- [ ] Clicking employee/project/client cards opens detail modals/panels
- [ ] Logout clears token and redirects to login
- [ ] 401 responses auto-redirect to login
- [ ] Responsive design works on mobile (check `/chat` and `/employees` at 375px width)

---

## Common Tasks

### Add a New API Endpoint

1. Add function to `src/services/api.ts`:
   ```tsx
   export const getWidget = async (widgetId: string): Promise<Widget> => {
     const { data } = await api.get<Widget>(`/widgets/${widgetId}`)
     return data
   }
   ```

2. Add type to `src/types/index.ts`:
   ```tsx
   export interface Widget {
     widget_id: string
     name: string
   }
   ```

3. Call it in a component:
   ```tsx
   const widget = await getWidget('123')
   ```

### Add a New Route/Page

1. Create `src/pages/WidgetPage.tsx`
2. Add route to `src/App.tsx`:
   ```tsx
   <Route path="/widget" element={<WidgetPage />} />
   ```
3. Add nav item to `src/components/Layout/Sidebar.tsx`
4. Import icon from lucide-react and add to `navItems` array

### Debug API Calls

1. Open DevTools (F12) → Network tab
2. Make a request (e.g., chat message)
3. See request/response in Network tab
4. Check if JWT token is in `Authorization` header
5. Check response status and data

### Add a New Utility Function

1. Create `src/utils/formatDate.ts`
2. Export function:
   ```tsx
   export const formatDate = (dateStr: string): string => {
     return new Date(dateStr).toLocaleDateString()
   }
   ```
3. Import and use in components:
   ```tsx
   import { formatDate } from '@/utils/formatDate'
   ```

---

## Tech Decision Notes

**Why Zustand over Redux?** — Simple, lightweight, no boilerplate. Auth is the only global state needed.

**Why Tailwind over CSS Modules?** — Fast iteration, consistent design, no naming conflicts, smaller bundle.

**Why React Router v6?** — Modern, hooks-based, nested routes, less boilerplate than v5.

**Why Vite over CRA?** — 10–100x faster dev server, faster builds, cleaner config, smaller default bundle.

**Why no component library?** — Keep frontend lean, custom Tailwind components are faster and more flexible than shadcn or Material-UI.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `npm install` fails | Delete `node_modules/` and `package-lock.json`, then retry |
| Dev server won't start | Check Node version (need 18+); kill any process on port 3000 |
| API calls 404 | Verify backend is running on `:8001`; check `vite.config.ts` proxy |
| TypeScript errors on build | Run `tsc --noEmit` locally to see all errors; fix and retry |
| 401 errors after login | Check `useAuthStore` is persisting token to localStorage; check JWT format |
| Tailwind styles not applying | Make sure `src/` is in `tailwind.config.js` content paths |
| CORS errors | Backend must allow `http://localhost:3000` in CORS headers |
