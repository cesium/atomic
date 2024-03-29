const colors = require("tailwindcss/colors");
const plugin = require('tailwindcss/plugin');

module.exports = {
  darkMode: 'selector',
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
    '../storybook/**/*.exs'
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.orange,
        secondary: colors.sky,
        success: colors.green,
        danger: colors.red,
        warning: colors.yellow,
        info: colors.blue,
        gray: colors.gray,
      },
      backgroundImage: {
        'hero-pattern': "url('/images/atomic_background.svg')",
      },
      keyframes: {
        wave: {
            '0%': { transform: 'rotate(0.0deg)' },
            '15%': { transform: 'rotate(14.0deg)' },
            '30%': { transform: 'rotate(-8.0deg)' },
            '40%': { transform: 'rotate(14.0deg)' },
            '50%': { transform: 'rotate(-4.0deg)' },
            '60%': { transform: 'rotate(10.0deg)' },
            '70%': { transform: 'rotate(0.0deg)' },
            '100%': { transform: 'rotate(0.0deg)' },
        },
        progress: {
            '0%': { width: '0%' },
            '100%': { width: '100%' },
        }
      },
      animation: {
          wave: 'wave 1.5s infinite',
          progress: 'progress 5s linear 1'
      },
      backgroundSize: {
        '75': '75%'
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    plugin(({addVariant}) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
    plugin(({addVariant}) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
    plugin(({addVariant}) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
    plugin(({addVariant}) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &']))
  ]
}
