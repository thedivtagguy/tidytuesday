<script lang="ts">
	import { CopyButton } from 'svelte-ux';
	import { selectedChapter } from '$lib/stores';
	import SparkHistogram from './SparkLine.svelte';
	import Location from './svg/Location.svelte';
	import ChapterStats from './ChapterStats.svelte';
	import EventsTable from './EventsTable.svelte';
	import { fade } from 'svelte/transition';
	import { Collapse } from 'svelte-ux';
	import Question from '$lib/components/svg/Question.svelte';
	import MeetupButton from './MeetupButton.svelte';
	import PillSelect from './PillSelect.svelte';
	import { page } from '$app/stores';

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
			<div class="flex justify-end w-full items-center">
				<span class="text-base-content font-medium text-xs">Share</span><CopyButton
					value={$page.url.href}
					color="#f2f2f2"
					variant="fill"
					size="sm"
				/>
			</div>
			<div class="flex items-center justify-between gap-4 w-full">
				<div class="w-full">
					<div class="flex justify-between w-full">
						<span class="text-sm font-bold text-[#843F85]">R-Ladies/</span>
					</div>
					<h2 class="uppercase text-3xl font-semibold">
						{cleanChapterName($selectedChapter.chapter)}
						<span class="block text-xs font-light text-gray-600 normal-case py-1"
							><Location class="inline mr-1" />{$selectedChapter.chapter_city}</span
						>
					</h2>
				</div>
				<SparkHistogram chapter_id={$selectedChapter.chapter_id} />
			</div>
			<ChapterStats meetups={$selectedChapter.meetups} />

			<Collapse>
				<div
					slot="trigger"
					class="border border-base-300 collapse collapse-arrow rounded-md flex-1 py-1 px-2"
				>
					Past events
				</div>
				<div>
					<EventsTable chapter_id={$selectedChapter.chapter_id} />
				</div>
			</Collapse>
			<div class="flex justify-between items-center">
				<MeetupButton
					href={`https://www.meetup.com/${$selectedChapter.chapter}`}
					text="Join group"
				/>
			</div>
			{#if $selectedChapter.similar_chapters.length > 0}
				<div class="py-2 mt-2 flex flex-col justify-start items-start">
					<div
						class="tooltip tooltip-bottom hover:cursor-pointer"
						data-tip="Based on this chapter's events"
					>
						<h3
							class=" flex justify-start items-center gap-1 text-left text-sm text-gray-700 w-full"
						>
							<span class="inline">
								<Question />
							</span>Similar chapters
						</h3>
					</div>
					<PillSelect initialChapterIds={$selectedChapter.similar_chapters} />
				</div>
			{/if}
		</div>
	{/key}
{:else}
	<div
		class="prose w-full mx-auto h-full min-h-[400px] flex items-center justify-center gap-4 py-8 px-6 rounded-md shadow-md"
	>
		<p class="text-base-300 uppercase font-bold border-[1px] border-base-300 px-4 py-2 rounded-lg">
			Select a chapter to know more
		</p>
	</div>
{/if}
