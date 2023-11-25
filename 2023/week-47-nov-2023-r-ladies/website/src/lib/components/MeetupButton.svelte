<script lang="ts">
	import NewTab from './svg/NewTab.svelte';
	export let text = 'Sign up';
	export let href = 'https://www.meetup.com/register/';
</script>

<a
	target="_blank"
	class="button inline-block h-10 w-36 mt-2 text-center font-medium hover:no-underline meetup-button"
	{href}>{text} <NewTab class="inline" /></a
>

<style>
	*,
	::after,
	::before {
		border-image: none 100% 1 0 stretch;
		border-style: solid;
		border-width: 0;
	}

	.meetup-button {
		font-family:
			Graphik Meetup,
			-apple-system,
			BlinkMacSystemFont,
			Roboto,
			Helvetica,
			Arial,
			sans-serif;
		font-size: 16px;
		line-height: 1.5;
		tab-size: 4;
	}

	a {
		text-decoration: none;
	}

	.button {
		background-color: #e32359;
		border-color: #e32359;
		border-radius: 8px;
		color: #fff;
		cursor: pointer;
		fill: #fff;
		padding: 8px 12px;
	}

	.button:hover {
		border-color: #e63a6a;
	}

	.button:focus,
	.button:hover {
		background-color: #e63a6a;
		text-decoration: none currentcolor solid;
	}

	.button:focus {
		border-color: #610c24;
	}
</style>
