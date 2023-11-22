/** @type {import('tailwindcss').Config} */
export default {
	content: [
		'./src/**/*.{html,svelte,js,ts}',
		'./node_modules/svelte-ux/**/*.{svelte,js}',
		'./node_modules/layerchart/**/*.{svelte,js}'
	],
	theme: {
		extend: {}
	},
	plugins: ['svelte-ux/plugins/tailwind.cjs']
};
