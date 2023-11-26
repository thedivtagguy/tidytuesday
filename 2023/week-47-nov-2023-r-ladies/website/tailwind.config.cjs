// /** @type {import('tailwindcss').Config} */
// export default {
// 	content: [
// 		'./src/**/*.{html,svelte,js,ts}',
// 		'./node_modules/svelte-ux/**/*.{svelte,js}',
// 		'./node_modules/layerchart/**/*.{svelte,js}'
// 	],
// 	theme: {
// 		extend: {}
// 	},
// 	daisyui: {
// 		themes: [
// 			'valentine',
// 			'dark',
// 			'cupcake',
// 			'bumblebee',
// 			'emerald',
// 			'corporate',
// 			'synthwave',
// 			'retrowave',
// 			'halloween',
// 			'aqua',
// 			'lofi',
// 			'pastel',
// 			'fantasy',
// 			'wireframe',
// 			'black',
// 			'luxury',
// 			'dracula'
// 		]
// 	},
// 	plugins: ['svelte-ux/plugins/tailwind.cjs', 'daisyui']
// };

module.exports = {
	content: [
		'./src/**/*.{html,svelte,js,ts}',
		'./node_modules/svelte-ux/**/*.{svelte,js}',
		'./node_modules/layerchart/**/*.{svelte,js}'
	],
	theme: {
		extend: {}
	},
	daisyui: {
		themes: ['valentine']
	},
	plugins: [
		'svelte-ux/plugins/tailwind.cjs',
		require('daisyui'),
		require('@tailwindcss/typography')
	]
};
