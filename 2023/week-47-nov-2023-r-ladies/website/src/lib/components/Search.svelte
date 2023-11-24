<script lang="ts">
	import Typeahead from 'svelte-typeahead';
	import type { MeetupData } from '$lib/types.ts';
	import { selectedLocation } from '$lib/stores';
	import rawData from '$lib/data/output.json';

	const meetupData: MeetupData = rawData as MeetupData;

	const searchItems: { id: number; text: string }[] = Array.from(meetupData).map((meetup) => {
		return {
			id: meetup.chapter_id,
			text: `${meetup.chapter_city} | ${meetup.chapter}`
		};
	});

	const extract = (item: { id: number; text: string }) => item.text;
</script>

<div class="py-4">
	<Typeahead
		label="Search for your city"
		data={searchItems}
		{extract}
		limit={10}
		on:select={({ detail }) => {
			selectedLocation.set({
				chapterId: +detail.original.id,
				chapter: detail.original.text.split(' | ')[1]
			});
		}}
		on:clear={() => {
			selectedLocation.set({
				chapterId: null,
				chapter: null
			});
		}}
	/>
</div>

<style>
	:global([data-svelte-typeahead]) {
		width: 100%;
		padding: 0.5rem;
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
