<script lang="ts">
	import Typeahead from 'svelte-typeahead';
	import type { MeetupData } from '$lib/types';
	import { selectedChapter, selectedKeyword, searchMode } from '$lib/stores';
	import { selectChapter, selectKeyword } from '$lib/utils';
	import rawData from '$lib/data/output.json';
	import PillSelect from './PillSelect.svelte';
	export let searchType: 'location' | 'topic' = 'topic';
	export let chapterQuickSelect: boolean = true;

	$: searchType = $searchMode;

	const meetupData: MeetupData = rawData as MeetupData;

	const searchLocations = meetupData.map(({ chapter_id, chapter_city, chapter }) => ({
		id: chapter_id,
		text: `${chapter_city} | ${chapter}`
	}));

	const searchKeywords = Array.from(
		new Set(
			meetupData
				.flatMap((d) => (d.keywords.length > 0 ? d.keywords.split(', ') : []))
				.map((k) => k.trim())
		)
	).map((keyword, index) => ({
		id: index,
		text: keyword
	}));

	let searchIndex: { id: number; text: string }[] = [];
	$: searchIndex = searchType === 'location' ? searchLocations : searchKeywords;

	const extract = (item: { id: number; text: string }) => item.text;

	function handleSelect(detail) {
		if (searchType === 'location') {
			selectChapter(parseInt(detail.original.id), meetupData);
		} else {
			selectKeyword(detail.original.text, meetupData);
		}
	}
</script>

<div class="search-container my-4 w-full max-w-[500px] mx-auto shadow-2xl">
	<div class="prose flex justify-center gap-2 items-center">
		<span class="text-accent-neutral uppercase font-bold text-sm">Topics</span>
		<input
			type="radio"
			name="radio-1"
			class="radio"
			checked={$searchMode === 'topic'}
			on:change={() => searchMode.set('topic')}
		/>
		<input
			type="radio"
			name="radio-1"
			class="radio"
			checked={$searchMode === 'location'}
			on:change={() => searchMode.set('location')}
		/>
		<span class="text-accent-neutral uppercase font-bold text-sm">Locations</span>
	</div>
	<Typeahead
		label={searchType === 'location' ? 'Search for your city' : 'Search for a topic'}
		value={searchType === 'location' && $selectedChapter.chapter
			? `${$selectedChapter.chapter_city} | ${$selectedChapter.chapter}`
			: searchType === 'topic' && $selectedKeyword
			? $selectedKeyword
			: ''}
		{extract}
		limit={5}
		on:select={({ detail }) => handleSelect(detail)}
		on:clear={() => {
			if (searchType === 'location') {
				selectedChapter.set({});
			} else {
				selectedKeyword.set('');
			}
		}}
		data={searchIndex}
		showDropdownOnFocus={true}
	/>
	{#if chapterQuickSelect}
		<PillSelect {meetupData} {searchKeywords} />
	{/if}
</div>

<style>
	.search-container {
		width: 100%;
		padding: 1rem;
		border-radius: 0.25rem;
		font-size: 1rem;
		line-height: 1.5;
		color: #4a5568;
		background-color: #e3d2de;
		background-clip: padding-box;
		transition:
			border-color 0.15s ease-in-out,
			box-shadow 0.15s ease-in-out;
	}

	/* Style data-svelte-typeahead */

	:global([data-svelte-typeahead], [data-svelte-typeahead] > form:nth-child(1)) {
		background-color: #e3d2de;
		color: #8f6271;
		font-weight: 500;
	}

	:global([data-svelte-typeahead] > label) {
		font-weight: 800;
	}
</style>
