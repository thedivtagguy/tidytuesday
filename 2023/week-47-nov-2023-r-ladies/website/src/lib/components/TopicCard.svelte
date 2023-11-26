<script lang="ts">
	import { selectedKeyword, keywordChapterList } from '$lib/stores';
	import Question from './svg/Question.svelte';
	import { fade } from 'svelte/transition';
	import TopicTable from './TopicTable.svelte';
</script>

{#if $selectedKeyword !== ''}
	{#key $selectedKeyword}
		<div
			in:fade={{ duration: 500 }}
			class="w-full mx-auto h-full py-8 px-6 rounded-md shadow-md transition-all duration-100"
		>
			<div class="stat m-0 p-0">
				<div class="stat-title">Chapters that have discussed</div>
				<div class="stat-value text-xl capitalize">{$selectedKeyword}</div>
			</div>
			<TopicTable />
			<div
				class="tooltip tooltip-top hover:cursor-pointer"
				data-tip="Based on AI extracted keywords, bound to have missed some words which mean the same thing"
			>
				<h3 class=" flex justify-start items-center gap-1 text-left text-xs text-gray-700 w-full">
					<span class="inline">
						<Question />
					</span>Probably not <i>entirely</i> representative
				</h3>
			</div>
		</div>
	{/key}
{:else}
	<div
		class="prose w-full mx-auto h-full min-h-[400px] flex items-center justify-center gap-4 py-8 px-6 rounded-md shadow-md"
	>
		<p class="text-base-300 uppercase font-bold border-[1px] border-base-300 px-4 py-2 rounded-lg">
			Select a topic to know more
		</p>
	</div>
{/if}
