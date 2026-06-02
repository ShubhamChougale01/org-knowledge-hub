/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        brand: {
          50:  '#eef2ff',
          100: '#e0e7ff',
          500: '#667eea',
          600: '#5b6fdb',
          700: '#4c5bc2',
          900: '#312e81',
        },
      },
    },
  },
  plugins: [],
}
