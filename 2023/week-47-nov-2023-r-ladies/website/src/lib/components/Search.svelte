<script lang="ts">
	import Typeahead from 'svelte-typeahead';
	import type { MeetupData, MeetupChapter } from '$lib/types';
	import { selectedChapter } from '$lib/stores';
	import { selectChapter } from '$lib/utils';
	import rawData from '$lib/data/output.json';
	import { min, max } from 'd3';
	import { fade } from 'svelte/transition';
	import Reload from '$lib/components/svg/Reload.svelte';
	export let searchType: 'location' | 'topic' = 'location';
	export let chapterQuickSelect: boolean = true;

	const meetupData: MeetupData = rawData as MeetupData;

	const searchLocations = meetupData.map(({ chapter_id, chapter_city, chapter }) => ({
		id: chapter_id,
		text: `${chapter_city} | ${chapter}`
	}));

	const searchTopics = meetupData.flatMap(({ chapter_id, meetups }) =>
		meetups.map((meetup) => ({
			id: chapter_id,
			text: meetup.title
		}))
	);

	const quickSelectOptions = Array.from(
		{ length: 4 },
		() =>
			Math.floor(
				Math.random() *
					(max(meetupData, (d) => d.chapter_id) - min(meetupData, (d) => d.chapter_id) + 1)
			) + min(meetupData, (d) => d.chapter_id)
	);

	let quickSelectData = quickSelectOptions.map((option) =>
		meetupData.find((d) => d.chapter_id === option)
	);

	function reloadQuickSelect() {
		let uniqueIds = new Set();
		while (uniqueIds.size < 4) {
			const randomId =
				Math.floor(
					Math.random() *
						(max(meetupData, (d) => d.chapter_id) - min(meetupData, (d) => d.chapter_id) + 1)
				) + min(meetupData, (d) => d.chapter_id);
			uniqueIds.add(randomId);
		}

		quickSelectData = Array.from(uniqueIds).map((id) =>
			meetupData.find((d) => d.chapter_id === id)
		);
	}

	let searchIndex: { id: number; text: string }[] = [];
	$: searchIndex = searchType === 'location' ? searchLocations : searchTopics;

	const extract = (item: { id: number; text: string }) => item.text;
</script>

<div class="search-container my-4 w-full min-w-[300px] max-w-[500px] mx-auto shadow-2xl">
	<Typeahead
		label="Search for your city"
		value={$selectedChapter.chapter
			? `${$selectedChapter.chapter_city} | ${$selectedChapter.chapter}`
			: ''}
		{extract}
		limit={10}
		on:select={({ detail }) => selectChapter(parseInt(detail.original.id), meetupData)}
		on:clear={() => selectedChapter.set({})}
		data={searchIndex}
	/>
	{#if chapterQuickSelect}
		<div class="flex justify-start pt-4 align-top">
			<div class="flex gap-2 flex-wrap">
				{#each quickSelectData as data, index (data.chapter_id)}
					<button
						in:fade={{ duration: 200, delay: index * 50 }}
						class="button-style bg-slate-100 text-xs font-semibold tracking-wide uppercase px-2 py-1 rounded-lg"
						on:click={() => selectChapter(data.chapter_id, meetupData)}
					>
						{data.chapter}
					</button>
				{/each}
			</div>
			<button
				class="button-style bg-gray-500 text-white text-xs font-semibold tracking-wide uppercase px-2 py-1 rounded-lg h-6"
				on:click={reloadQuickSelect}
			>
				<Reload />
			</button>
		</div>
	{/if}
</div>

<style>
	.search-container {
		width: 100%;
		padding: 1rem;
		border: 1px solid #e2e8f0;
		border-radius: 0.25rem;
		font-size: 1rem;
		line-height: 1.5;
		color: #4a5568;
		background-color: #fff;
		background-clip: padding-box;
		transition:
			border-color 0.15s ease-in-out,
			box-shadow 0.15s ease-in-out;
	}
</style>
