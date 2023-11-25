<script lang="ts">
	import { selectedChapter } from '$lib/stores';
	import SparkHistogram from './SparkLine.svelte';
	import Location from './svg/Location.svelte';
	import EventsTable from './EventsTable.svelte';
	import { fade } from 'svelte/transition';
	import { Collapse } from 'svelte-ux';
	import MeetupButton from './MeetupButton.svelte';
	import PillSelect from './PillSelect.svelte';

	function cleanChapterName(chapter: string) {
		return chapter.replace('rladies-', '');
	}
</script>

{#if $selectedChapter.chapter_id}
	{#key $selectedChapter.chapter_id}
		<div
			in:fade={{ duration: 500 }}
			class="w-full mx-auto h-full py-8 px-6 rounded-md shadow-md transition-all duration-100"
		>
			<div class="flex items-center justify-between gap-4">
				<div>
					<span class="text-sm font-bold text-[#843F85]">R-Ladies/</span>
					<h2 class="uppercase text-3xl font-semibold">
						{cleanChapterName($selectedChapter.chapter)}
						<span class="block text-xs font-light text-gray-600 normal-case py-1"
							><Location class="inline mr-1" />{$selectedChapter.chapter_city}</span
						>
					</h2>
				</div>
				<SparkHistogram chapter_id={$selectedChapter.chapter_id} />
			</div>
			<MeetupButton href={`https://www.meetup.com/${$selectedChapter.chapter}`} text="Join group" />
			<Collapse name="Explore past events">
				<div>
					<EventsTable chapter_id={$selectedChapter.chapter_id} />
				</div>
			</Collapse>
			{#if $selectedChapter.similar_chapters.length > 0}
				<div class="py-2">
					<h3>Similar chapters</h3>
					<PillSelect initialChapterIds={$selectedChapter.similar_chapters} />
				</div>
			{/if}
		</div>
	{/key}
{:else}
	<div
		class="w-full mx-auto h-full min-h-[400px] flex items-center justify-center gap-4 py-8 px-6 rounded-md shadow-md"
	>
		<h2 class="uppercase text-3xl font-semibold">Select a chapter to know more</h2>
	</div>
{/if}
