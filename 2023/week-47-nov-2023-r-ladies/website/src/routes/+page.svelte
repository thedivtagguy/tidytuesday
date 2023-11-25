<script lang="ts">
	import Globe from '$lib/components/Globe.svelte';
	import Search from '$lib/components/Search.svelte';
	import ChapterCard from '$lib/components/ChapterCard.svelte';
</script>

<main class="flex md:flex-row flex-col justify-center items-center w-full">
	<section class="flex flex-col justify-center px-8">
		<div class="flex flex-col items-center justify-center gap-4">
			<h1 class="text-6xl font-bold flex-grow-0">R Ladies</h1>
			<p>This is some text about what Rladies is and what not</p>
		</div>
	</section>
	<section class="globe max-w-[800px] w-full px-4 relative">
		<Globe />
		<div class="datatable py-2 absolute bottom-0 mx-auto w-full">
			<Search />
		</div>
	</section>
	<section class="flex flex-col justify-center px-8 w-full max-w-[500px]">
		<ChapterCard />
	</section>
</main>
