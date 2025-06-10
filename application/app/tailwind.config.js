/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#0055aa',
        secondary: '#e6f2ff',
        text: '#333',
        light: '#f8f9fa',
        border: '#eee'
      },
      fontFamily: {
        sans: ['Arial', 'sans-serif']
      },
      spacing: {
        'xs': '0.25rem',  // 4px
        'sm': '0.5rem',   // 8px
        'md': '1rem',     // 16px
        'lg': '1.5rem',   // 24px
        'xl': '2rem',     // 32px
      }
    },
  },
  plugins: [],
}

