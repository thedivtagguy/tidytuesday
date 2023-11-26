<script lang="ts">
	import { min, max } from 'd3';
	import { fade } from 'svelte/transition';
	import { selectChapter, selectKeyword } from '$lib/utils';
	import Reload from '$lib/components/svg/Reload.svelte';
	import type { MeetupChapter } from '$lib/types';
	import meetupData from '$lib/data/output.json';
	import { searchMode } from '$lib/stores';

	export let initialChapterIds: number[] = [];
	export let searchKeywords: { id: number; text: string }[] = [];
	$: searchType = $searchMode;

	$: initialChapterIds = Array.from(new Set(initialChapterIds));
	// Upto 4 items can be selected
	$: if (initialChapterIds.length > 4) {
		initialChapterIds = initialChapterIds.slice(0, 4);
	}

	let pillSelectData: MeetupChapter[] | string[];

	$: {
		if (searchType === 'location') {
			pillSelectData =
				initialChapterIds.length > 0
					? initialChapterIds
							.map((id) => meetupData.find((d) => d.chapter_id === id))
							.filter((d) => d)
					: generateRandomChapters();
		} else {
			// get 4 random search keywords from the text property of the searchKeywords array{ id: 667, text: "data processing"
			pillSelectData = searchKeywords
				.sort(() => Math.random() - Math.random())
				.slice(0, 4)
				.map((d) => d.text);
		}
	}

	function generateRandomChapters() {
		let uniqueIds = new Set();
		while (uniqueIds.size < 4) {
			const randomId =
				Math.floor(
					Math.random() *
						(max(meetupData, (d) => d.chapter_id) - min(meetupData, (d) => d.chapter_id) + 1)
				) + min(meetupData, (d) => d.chapter_id);
			uniqueIds.add(randomId);
		}
		return Array.from(uniqueIds)
			.map((id) => meetupData.find((d) => d.chapter_id === id))
			.filter((d) => d !== undefined);
	}

	function reloadQuickSelect() {
		if (searchType === 'location') {
			pillSelectData = generateRandomChapters();
		} else {
			pillSelectData = searchKeywords
				.sort(() => Math.random() - Math.random())
				.slice(0, 4)
				.map((d) => d.text);
		}
	}

	function handleClick(item) {
		if (searchType === 'location') {
			selectChapter(item.chapter_id, meetupData);
		} else {
			selectKeyword(item, meetupData);
		}
	}

	$: console.log(pillSelectData);
</script>

<div class="flex justify-start pt-4 gap-2 align-top">
	<div class="flex gap-2 flex-wrap">
		{#each pillSelectData as data, index (`${index}-${$searchMode === 'topic' ? data : data.chapter_id}`)}
			{#key `${index}-${$searchMode === 'topic' ? data : data.chapter_id}`}
				<button
					in:fade={{ duration: 200, delay: index * 100 }}
					class="kbd text-sm tracking-wide title-case px-2 py-1 rounded-lg h-6 hover:bg-[#ab93a5] hover:text-white"
					on:click={() => handleClick(data)}
				>
					{searchType === 'location' ? data.chapter : data}
				</button>
			{/key}
		{/each}
	</div>
	{#if initialChapterIds.length === 0}
		<button
			class="kbd bg-[#b0a4ac] text-sm tracking-wide title-case px-2 py-1 rounded-lg h-6 hover:bg-[#ab93a5] text-white"
			on:click={reloadQuickSelect}
		>
			<Reload />
		</button>
	{/if}
</div>
