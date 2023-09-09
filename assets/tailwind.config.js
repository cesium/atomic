// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require('tailwindcss/plugin')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex',
  ],
  theme: {
    extend: {
      border: {
        '1': '1px'
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
        }
      },
      animation: {
          wave: 'wave 1.5s infinite'
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
