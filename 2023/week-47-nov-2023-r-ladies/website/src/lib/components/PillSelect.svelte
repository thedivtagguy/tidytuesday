<script lang="ts">
	import { selectChapter } from '$lib/utils';
	import { min, max } from 'd3';
	import Reload from '$lib/components/svg/Reload.svelte';
	import type { MeetupData, MeetupChapter } from '$lib/types';
	import meetupData from '$lib/data/output.json';
	export let initialChapterIds: number[] = [];

	$: initialChapterIds = Array.from(new Set(initialChapterIds));

	let pillSelectData: MeetupChapter[];

	$: pillSelectData =
		initialChapterIds.length > 0
			? initialChapterIds
					.map((id) => meetupData.find((d) => d.chapter_id === id))
					.filter((d) => d !== undefined)
			: generateRandomChapters();

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
		pillSelectData = generateRandomChapters();
	}
</script>

<div class="flex justify-start pt-4 align-top">
	<div class="flex gap-2 flex-wrap">
		{#each pillSelectData as data, index (data.chapter_id)}
			<button
				class="button-style bg-slate-100 text-xs font-semibold tracking-wide uppercase px-2 py-1 rounded-lg"
				on:click={() => selectChapter(data.chapter_id, meetupData)}
			>
				{data.chapter}
			</button>
		{/each}
	</div>
	{#if initialChapterIds.length === 0}
		<button
			class="button-style bg-gray-500 text-white text-xs font-semibold tracking-wide uppercase px-2 py-1 rounded-lg h-6"
			on:click={reloadQuickSelect}
		>
			<Reload />
		</button>
	{/if}
</div>
