<script lang="ts">
	import { Paginate, Pagination, Table } from 'svelte-ux';
	import type { MeetupData } from '$lib/types.ts';
	import rawData from '$lib/data/output.json';

	export let chapter_id: number | undefined;
	const meetupData: MeetupData = rawData as MeetupData;

	$: meetups = meetupData
		.filter((d) => d.chapter_id === chapter_id)
		.map((d) => d.meetups)
		.flat();
</script>

<div class="py-4">
	<Paginate items={meetups} perPage={3} let:pageItems let:pagination>
		<Table
			data={pageItems}
			columns={[
				{
					name: 'title',
					align: 'left'
				},

				{
					name: 'date',
					align: 'right'
				}
			]}
		>
			<thead slot="headers">
				<tr>
					<th class="px-2 text-sm font-medium py-2 text-left">Topic</th>
					<th class="px-2 text-sm font-medium py-2 text-left">Held on</th>
				</tr>
			</thead><tbody slot="data" let:columns let:data let:getCellValue>
				{#each data ?? [] as rowData, rowIndex}
					<!-- Each alternate row is gray -->
					<tr class={rowIndex % 2 === 0 ? 'bg-[#E3D2DE]' : ''}>
						{#each columns as column}
							{@const value = getCellValue(column, rowData, rowIndex)}
							<td class="px-2 py-2 max-w-[12rem]">
								<div class="text-sm">{value}</div>
							</td>
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
