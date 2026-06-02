---
name: react-components
description: React 18 + TypeScript component patterns, Tailwind styling, Zustand store, and page structure. Use when building or modifying React components, pages, or state management.
---

## Frontend Stack & Tech

- **React 18.3.1** with TypeScript 5.6.3
- **Vite 5.4.10** for fast builds and HMR
- **React Router 6.27.0** for client-side routing
- **Tailwind CSS 3.4.14** for styling (no component library)
- **Zustand 5.0.0** for lightweight state (auth only)
- **Axios 1.7.7** with JWT interceptors for API calls
- **Lucide-react 0.460.0** for icons
- **React Flow 11.11.4** for interactive org chart graph visualization

## Directory Structure

```
frontend/src/
├── main.tsx                 # App entry
├── App.tsx                  # Route definitions
├── index.css                # Global styles + Tailwind
│
├── pages/                   # Full page components
│   ├── LoginPage.tsx       # Email/password login form
│   ├── ChatPage.tsx        # Main chat interface
│   ├── OrgChartPage.tsx    # Interactive org hierarchy (React Flow)
│   ├── EmployeesPage.tsx   # Employee list + filtering
│   ├── ProjectsPage.tsx    # Project browsing
│   └── ClientsPage.tsx     # Client browsing
│
├── components/
│   ├── Layout/             # App-wide layout wrappers
│   │   ├── AppLayout.tsx  # Main layout with sidebar
│   │   └── Sidebar.tsx    # Navigation sidebar
│   ├── Chat/               # Chat interface components
│   ├── Employee/           # Employee card/detail components
│   └── OrgChart/           # React Flow org chart components
│
├── services/
│   └── api.ts              # Axios client with JWT interceptors
│
├── store/
│   └── auth.ts             # Zustand auth state (user, token)
│
└── types/
    └── index.ts            # TypeScript interfaces (User, Employee, etc.)
```

## Running the Frontend

```bash
cd frontend
npm install
npm run dev              # Start dev server on http://localhost:5173 (or 3000 in config)
npm run build           # Production build → dist/
npm run preview         # Preview production build locally
```

Vite config includes proxy for `/api` calls to backend at `http://localhost:8001`.

## Component Patterns

### Functional Component with Hooks

```tsx
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

interface MyComponentProps {
  userId: string;
  onSelect?: (id: string) => void;
}

export const MyComponent: React.FC<MyComponentProps> = ({ userId, onSelect }) => {
  const [data, setData] = useState<Employee | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    fetchData();
  }, [userId]);

  const fetchData = async () => {
    setLoading(true);
    try {
      const response = await api.get(`/employees/${userId}`);
      setData(response.data);
    } catch (err) {
      setError((err as Error).message);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div className="p-4">Loading...</div>;
  if (error) return <div className="p-4 text-red-600">Error: {error}</div>;

  return (
    <div className="p-4">
      {data && (
        <>
          <h1 className="text-2xl font-bold mb-4">{data.name}</h1>
          <p className="text-gray-600">{data.email}</p>
        </>
      )}
    </div>
  );
};
```

## Styling with Tailwind

**No custom CSS files** — Use Tailwind utility classes directly in JSX:

```tsx
// Colors: bg-blue-600, text-gray-700, hover:bg-blue-700
// Spacing: p-4 (padding), m-2 (margin), gap-4 (flex gap)
// Typography: text-2xl, font-bold, font-semibold
// Layout: flex, flex-col, grid, grid-cols-3

return (
  <div className="flex flex-col gap-4 p-6 bg-white rounded-lg shadow-md">
    <h2 className="text-xl font-bold text-gray-900">Title</h2>
    <p className="text-gray-600">Description</p>
    <button className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
      Click Me
    </button>
  </div>
);
```

**Common patterns:**
- `bg-gray-50` / `bg-white` — backgrounds
- `text-sm` / `text-base` / `text-lg` / `text-xl` — font sizes
- `font-semibold` / `font-bold` — font weights
- `rounded`, `rounded-lg`, `rounded-full` — borders
- `shadow`, `shadow-md`, `shadow-lg` — drop shadows
- `border`, `border-gray-200`, `border-l-4 border-blue-500` — borders
- `hover:*`, `focus:*`, `disabled:*` — interactive states

## State Management: Zustand

Auth state lives in `src/store/auth.ts`:

```tsx
import { create } from 'zustand';

interface User {
  id: string;
  email: string;
  accessLevel: number;
}

interface AuthStore {
  user: User | null;
  token: string | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

export const useAuthStore = create<AuthStore>((set) => ({
  user: null,
  token: localStorage.getItem('token'),
  login: async (email, password) => {
    const response = await api.post('/auth/login', { email, password });
    set({ user: response.data.user, token: response.data.access_token });
    localStorage.setItem('token', response.data.access_token);
  },
  logout: () => {
    set({ user: null, token: null });
    localStorage.removeItem('token');
  },
}));

// Usage in components:
const { user, logout } = useAuthStore();
```

## API Calls with Axios

`src/services/api.ts` configures Axios with JWT interceptors:

```tsx
import axios from 'axios';
import { useAuthStore } from '../store/auth';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8001',
});

// Interceptor adds JWT token to all requests
api.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
```

**Usage:**
```tsx
// GET request
const response = await api.get('/employees/123');

// POST request
const response = await api.post('/chat', { message: 'Who is the CEO?' });

// Error handling
try {
  const data = await api.get('/employees');
} catch (error) {
  if (error.response?.status === 401) {
    // Unauthorized — redirect to login
  }
}
```

## Pages vs. Components

**Pages** (`src/pages/`) — Full page views with layout:
- Responsible for data fetching, routing logic
- Include all sections on that route
- Use `useNavigate()` for page transitions

**Components** (`src/components/`) — Reusable UI units:
- Accept props, stay focused
- Can be used on multiple pages
- No direct navigation; emit events via callbacks

## Icons with Lucide-react

```tsx
import { ChevronDown, User, LogOut, Search } from 'lucide-react';

return (
  <button className="flex items-center gap-2">
    <User size={20} className="text-gray-600" />
    Profile
  </button>
);
```

450+ icons available. Check [lucide.dev](https://lucide.dev/) for names.

## Testing Pages

To confirm a change works, run:
```bash
npm run dev
```

Visit the page in browser at `http://localhost:5173` (or configured port) and:
1. Test the golden path (happy case)
2. Test edge cases (empty state, loading, error, filtering)
3. Check responsive design (small screen, tablet, desktop)
4. Verify links navigate correctly
5. Confirm forms submit data to backend correctly

## Common Patterns

| Pattern | Example |
|---|---|
| Conditional render | `{data && <div>{data.name}</div>}` or `{data ? <div>...</div> : <p>Loading...</p>}` |
| List render | `{items.map(item => <ItemCard key={item.id} item={item} />)}` |
| Form input | `<input type="email" value={email} onChange={e => setEmail(e.target.value)} />` |
| Button states | `disabled={loading}`, `className={loading ? 'opacity-50' : ''}` |
| Async operations | Use `useState` for data/loading/error, `useEffect` for fetching |

## TypeScript Interfaces

Define in `src/types/index.ts`:

```tsx
export interface User {
  id: string;
  email: string;
  accessLevel: 1 | 2 | 3 | 4;
}

export interface Employee {
  id: string;
  name: string;
  email: string;
  department: string;
  role: string;
  skills: string[];
}

export interface ChatMessage {
  role: 'user' | 'assistant';
  content: string;
}
```

Use these throughout components for type safety.

