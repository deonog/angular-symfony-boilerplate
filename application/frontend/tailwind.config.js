/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#2563eb',
          dark: '#1d4ed8',
          light: '#3b82f6'
        },
        secondary: {
          DEFAULT: '#f1f5f9',
          dark: '#e2e8f0'
        },
        accent: '#10b981',
        text: {
          DEFAULT: '#1e293b',
          muted: '#64748b',
          light: '#94a3b8'
        },
        background: {
          DEFAULT: '#ffffff',
          alt: '#f8fafc'
        },
        border: '#e2e8f0',
        success: '#10b981',
        warning: '#f59e0b',
        error: '#ef4444'
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif']
      },
      spacing: {
        'xs': '0.25rem',
        'sm': '0.5rem',
        'md': '1rem',
        'lg': '1.5rem',
        'xl': '2rem',
        '2xl': '3rem'
      },
      borderRadius: {
        'sm': '0.25rem',
        'md': '0.5rem',
        'lg': '0.75rem',
        'xl': '1rem'
      }
    },
  },
  plugins: [],
}
