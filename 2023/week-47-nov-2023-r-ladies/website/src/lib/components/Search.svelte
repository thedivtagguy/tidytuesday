<script lang="ts">
	import Typeahead from 'svelte-typeahead';
	import type { MeetupData, MeetupChapter } from '$lib/types';
	import { selectedChapter } from '$lib/stores';
	import { selectChapter } from '$lib/utils';
	import rawData from '$lib/data/output.json';
	import PillSelect from './PillSelect.svelte';
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
		<PillSelect {meetupData} />
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
