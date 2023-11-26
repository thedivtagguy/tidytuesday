<script>
	export let content;
</script>

<footer class="footer p-10 bg-neutral text-white">
	<aside>
		<h3 class="prose text-base-200 font-bold">Methodology</h3>
		<div class="footer-text md:w-2/5">
			<svelte:component this={content} />
		</div>
	</aside>
</footer>
