<script>
	import '../lib/styles.css';
	import Footer from '$lib/components/Footer.svelte';
	export let data;
</script>

<main class="py-10 min-h-screen flex justify-center items-center w-full overflow-x-hidden">
	<slot />
</main>

<Footer content={data.content} />
