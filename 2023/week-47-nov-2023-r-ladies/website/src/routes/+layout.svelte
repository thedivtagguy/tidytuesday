<script>
	import '../lib/styles.css';
	import Footer from '$lib/components/Footer.svelte';

	export let data;
</script>

<svelte:head>
	<title>R-Ladies Chapter Explorer</title>
	<meta name="description" content="Explore R-ladies chapters in an interactive globe" />
	<link rel="canonical" href="https://rladies-explore.netlify.app/" />
	<link
		rel="shortcut icon"
		href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🇷</text></svg>"
	/>
	<link
		rel="icon"
		href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🇷</text></svg>"
	/>

	<!-- Open Graph / Facebook -->
	<meta property="og:url" content="https://rladies-explore.netlify.app/" />
	<meta property="og:type" content="website" />
	<meta property="og:title" content="R-Ladies chapters across the world" />
	<meta property="og:description" content="Explore R-ladies chapters in an interactive globe" />
	<meta property="og:locale" content="en_US" />
	<meta property="og:locale:alternate" content="en_IN" />
	<meta
		property="og:keywords"
		content="r-ladies, r, r communities, rladies, r-ladies communities, r-ladies chapters, interactive, maps"
	/>
	<meta property="og:image" content="/sharecard.png" />
	<meta property="og:site_name" content="thedivtagguy" />

	<!-- Twitter -->
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:site" content="@thedivtagguy" />
	<meta name="twitter:creator" content="@thedivtagguy" />
	<meta name="twitter:domain" content="https://thedivtagguy.com/" />
	<meta name="twitter:title" content="R-Ladies chapters across the world" />
	<meta name="twitter:description" content="Explore R-ladies chapters in an interactive globe" />
	<meta name="twitter:image" content="/sharecard.png" />
</svelte:head>

<main class="py-10 min-h-[99vh] flex justify-center items-center w-full overflow-x-hidden">
	<slot />
</main>

<Footer content={data.content} />
