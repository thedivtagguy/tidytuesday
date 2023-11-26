<script lang="ts">
	import Globe from '$lib/components/Globe.svelte';
	import Search from '$lib/components/Search.svelte';
	import ChapterCard from '$lib/components/ChapterCard.svelte';
	import TopicCard from '$lib/components/TopicCard.svelte';
	import Logo from '$lib/images/logo2.png';
	import { searchMode } from '$lib/stores';
</script>

<main class="flex md:flex-row flex-col justify-center items-center w-full">
	<section class="flex flex-col justify-center px-8">
		<div class="flex flex-col justify-center gap-4">
			<div class=" flex flex-col justify-start items-start">
				<div class="avatar">
					<div class="w-28 rounded-xl">
						<img src={Logo} alt="R-Ladies Global" />
					</div>
				</div>
				<div class="prose">
					<h1>R-Ladies Global</h1>
				</div>
			</div>
			<p class="max-w-md">
				R-Ladies is a global initiative enhancing gender diversity in the R community with local
				meetups, workshops, and mentorship. Since 2012, it's expanded to nearly 200 chapters
				worldwide. Offering both in-person and online events, R-Ladies allows participation
				regardless of location, and is one of the best ways to meet fellow R enthusiasts and learn
				together!

				<br />
				<br />

				Explore this map to find a meetup near you, or search for topics that chapters have covered
				in the past.
			</p>
		</div>
		<a href="https://rladies.org/" target="_blank"
			><button class="btn btn-wide bg-[#E3D2DE] rounded-md mt-4">Learn more on their website</button
			></a
		>
	</section>
	<section class="globe max-w-[800px] w-full px-4 relative">
		<Globe />
		<div class="datatable py-2 absolute bottom-0 mx-auto w-full">
			<Search />
		</div>
	</section>
	<section class="flex flex-col justify-center px-8 w-full max-w-[500px]">
		{#if $searchMode === 'location'}
			<ChapterCard />
		{:else if $searchMode === 'topic'}
			<TopicCard />
		{/if}
	</section>
</main>
