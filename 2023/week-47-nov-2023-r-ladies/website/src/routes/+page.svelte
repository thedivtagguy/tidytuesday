<script lang="ts">
	import Globe from '$lib/components/Globe.svelte';
	import LocateUser from '$lib/components/FindUserLocation.svelte';
	import Table from '$lib/components/Table.svelte';
	import Search from '$lib/components/Search.svelte';
</script>

<main class="flex md:flex-row flex-col justify-between items-center">
	<section class="flex flex-col justify-center">
		<div class="flex md:flex-row flex-col items-center justify-center gap-4">
			<h1 class="text-6xl font-bold flex-grow-0">R Ladies</h1>
			<p>This is some text about what Rladies is and what not</p>
		</div>
	</section>
	<section class="globe max-w-[800px] w-full px-4">
		<Globe />
	</section>
	<section class="datatable py-2">
		<Search />
		<Table />
	</section>
</main>
