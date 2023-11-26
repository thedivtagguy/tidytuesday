<script lang="ts">
	import { Paginate, Pagination, Table } from 'svelte-ux';
	import { keywordChapterList } from '$lib/stores';
	import { selectChapter } from '$lib/utils';
	import meetupData from '$lib/data/output.json';

	$: meetups = $keywordChapterList;
</script>

<div class="py-4">
	<Paginate items={meetups} perPage={5} let:pageItems let:pagination>
		<Table
			data={pageItems}
			columns={[
				{
					name: 'chapter',
					align: 'left'
				},

				{
					name: 'chapter_id',
					align: 'right'
				}
			]}
		>
			<thead slot="headers">
				<tr>
					<th class="px-2 text-sm font-medium py-2 text-left">Chapter</th>
				</tr>
			</thead><tbody slot="data" let:columns let:data let:getCellValue>
				{#each data ?? [] as rowData, rowIndex}
					<!-- Each alternate row is gray -->
					<tr class={rowIndex % 2 === 0 ? 'bg-[#f6d8ed]' : ''}>
						{#each columns as column}
							{@const value = getCellValue(column, rowData, rowIndex)}
							{@const chapterCleaned =
								column.name === 'chapter' ? value.replace('rladies-', '') : value}

							{#if column.name === 'chapter'}
								<td class="px-2 py-2 max-w-[12rem]">
									<div class="text-sm capitalize">
										{chapterCleaned}
									</div>
								</td>
							{:else if column.name === 'chapter_id'}
								<td class="px-2 py-2 max-w-[12rem]">
									<div class="text-sm text-right">
										<button
											on:click={() => selectChapter(value, meetupData)}
											class="kbd text-sm tracking-wide title-case px-2 py-1 rounded-lg h-6 hover:bg-[#ab93a5] hover:text-white"
										>
											Explore
										</button>
									</div>
								</td>
							{:else}
								<td class="px-2 py-2 max-w-[12rem]">
									<div class="text-sm">{value}</div>
								</td>
							{/if}
						{/each}
					</tr>{/each}
			</tbody>
		</Table>
		<Pagination
			{pagination}
			show={['pagination', 'prevPage', 'nextPage']}
			classes={{
				root: 'border-t py-1 mt-1',
				perPage: 'flex-1 text-left',
				pagination: 'px-2 '
			}}
		/>
	</Paginate>
</div>
