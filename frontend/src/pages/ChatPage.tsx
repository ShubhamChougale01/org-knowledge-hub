import { useState, useRef, useEffect, FormEvent } from 'react'
import { Send, ExternalLink, Bot, User as UserIcon, Database, Zap, Copy, Check } from 'lucide-react'
import { sendChatMessage } from '@/services/api'
import type { ChatResponse } from '@/types'

const generateSessionId = () => `session-${Date.now()}-${Math.random().toString(36).slice(2, 9)}`

interface Message {
  role: 'user' | 'bot'
  text: string
  meta?: ChatResponse
}

const SUGGESTED_QUESTIONS = [
  'Who works on NeuraVault?',
  'How many projects does TechVentures Inc have and who works on them?',
  'What is Ravi Shankar\'s performance on NeuraVault?',
  'Who has 4 stars on NeuraVault?',
  'How many employees work in Tech?',
  'Who has Neo4j certification?',
]

export default function ChatPage() {
  const [messages, setMessages] = useState<Message[]>([])
  const [input, setInput] = useState('')
  const [loading, setLoading] = useState(false)
  const scrollRef = useRef<HTMLDivElement>(null)
  const sessionId = useRef<string>(generateSessionId())

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: 'smooth' })
  }, [messages])

  const ask = async (question: string) => {
    if (!question.trim() || loading) return
    setInput('')
    setMessages((m) => [...m, { role: 'user', text: question }])
    setLoading(true)
    try {
      const response = await sendChatMessage({ query: question, session_id: sessionId.current })
      setMessages((m) => [...m, { role: 'bot', text: response.answer, meta: response }])
    } catch (err: any) {
      setMessages((m) => [
        ...m,
        {
          role: 'bot',
          text:
            err.response?.data?.detail ||
            'Sorry, something went wrong while processing your question.',
        },
      ])
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    ask(input)
  }

  return (
    <div className="flex flex-col h-screen">
      {/* Header */}
      <header className="bg-white border-b px-6 py-4 flex items-center justify-between sticky top-0 z-10">
        <div>
          <h1 className="text-2xl font-bold text-slate-800">Knowledge Chat</h1>
          <p className="text-sm text-slate-500">Ask anything about employees, projects, and clients</p>
        </div>
      </header>

      {/* Messages */}
      <div ref={scrollRef} className="flex-1 overflow-y-auto p-6 space-y-4">
        {messages.length === 0 && (
          <div className="max-w-2xl mx-auto">
            <div className="bg-white border border-slate-200 rounded-xl p-6 mb-6 text-center">
              <Bot size={40} className="mx-auto mb-3 text-brand-500" />
              <h2 className="text-xl font-semibold text-slate-800 mb-2">Hi! Ask me anything</h2>
              <p className="text-sm text-slate-500">
                I have access to your full organization knowledge graph. Try one of these:
              </p>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              {SUGGESTED_QUESTIONS.map((q) => (
                <button
                  key={q}
                  onClick={() => ask(q)}
                  className="text-left p-4 bg-white border border-slate-200 hover:border-brand-500 hover:shadow-md rounded-lg transition-all text-sm text-slate-700"
                >
                  {q}
                </button>
              ))}
            </div>
          </div>
        )}

        {messages.map((msg, idx) => (
          <MessageBubble key={idx} msg={msg} />
        ))}

        {loading && (
          <div className="flex items-center gap-3 max-w-3xl">
            <div className="flex-shrink-0 w-9 h-9 rounded-full bg-brand-100 text-brand-700 flex items-center justify-center">
              <Bot size={18} />
            </div>
            <div className="bg-white border border-slate-200 rounded-lg px-4 py-3 text-sm text-slate-500">
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 bg-brand-500 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
                <div className="w-2 h-2 bg-brand-500 rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
                <div className="w-2 h-2 bg-brand-500 rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Input */}
      <form onSubmit={handleSubmit} className="bg-white border-t p-4">
        <div className="max-w-4xl mx-auto flex gap-2">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Ask something about your organization..."
            disabled={loading}
            className="flex-1 px-4 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-brand-500 focus:border-transparent outline-none disabled:bg-slate-100"
          />
          <button
            type="submit"
            disabled={loading || !input.trim()}
            className="flex items-center gap-2 bg-brand-600 hover:bg-brand-700 text-white px-5 py-3 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Send size={16} />
            Send
          </button>
        </div>
      </form>
    </div>
  )
}

function MessageBubble({ msg }: { msg: Message }) {
  const [copied, setCopied] = useState(false)
  const [showCypher, setShowCypher] = useState(false)

  const handleCopy = () => {
    navigator.clipboard.writeText(msg.text)
    setCopied(true)
    setTimeout(() => setCopied(false), 1500)
  }

  if (msg.role === 'user') {
    return (
      <div className="flex items-start gap-3 max-w-3xl ml-auto">
        <div className="bg-brand-600 text-white rounded-lg px-4 py-3 text-sm">
          {msg.text}
        </div>
        <div className="flex-shrink-0 w-9 h-9 rounded-full bg-slate-200 text-slate-600 flex items-center justify-center">
          <UserIcon size={18} />
        </div>
      </div>
    )
  }

  return (
    <div className="flex items-start gap-3 max-w-3xl">
      <div className="flex-shrink-0 w-9 h-9 rounded-full bg-brand-100 text-brand-700 flex items-center justify-center">
        <Bot size={18} />
      </div>
      <div className="flex-1 bg-white border border-slate-200 rounded-lg p-4 text-sm">
        <p className="text-slate-800 whitespace-pre-wrap leading-relaxed">{msg.text}</p>

        {msg.meta && (
          <div className="mt-3 pt-3 border-t border-slate-100 flex items-center justify-between gap-4 text-xs text-slate-500">
            <div className="flex items-center gap-3">
              <span className="flex items-center gap-1">
                <Zap size={12} /> {msg.meta.execution_ms}ms
              </span>
              <span className="flex items-center gap-1">
                <Database size={12} /> {msg.meta.row_count} rows
              </span>
              {msg.meta.from_cache && (
                <span className="px-2 py-0.5 bg-green-100 text-green-700 rounded">cached</span>
              )}
              {msg.meta.cypher_used && (
                <button
                  onClick={() => setShowCypher((s) => !s)}
                  className="text-brand-600 hover:underline"
                >
                  {showCypher ? 'Hide' : 'View'} Cypher
                </button>
              )}
              {msg.meta.trace_url && (
                <a
                  href={msg.meta.trace_url}
                  target="_blank"
                  rel="noreferrer"
                  className="flex items-center gap-1 text-brand-600 hover:underline"
                >
                  Trace <ExternalLink size={11} />
                </a>
              )}
            </div>
            <button
              onClick={handleCopy}
              className="flex items-center gap-1 text-slate-500 hover:text-brand-600"
            >
              {copied ? <Check size={12} /> : <Copy size={12} />}
              {copied ? 'Copied' : 'Copy'}
            </button>
          </div>
        )}

        {showCypher && msg.meta?.cypher_used && (
          <pre className="mt-2 p-3 bg-slate-900 text-slate-100 text-xs rounded overflow-x-auto whitespace-pre-wrap">
            {msg.meta.cypher_used}
          </pre>
        )}
      </div>
    </div>
  )
}
