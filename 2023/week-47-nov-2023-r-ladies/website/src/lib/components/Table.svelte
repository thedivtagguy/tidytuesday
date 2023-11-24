<script lang="ts">
	import { Paginate, Pagination } from 'svelte-ux';
	import type { MeetupData } from '$lib/types.ts';
	import rawData from '$lib/data/output.json';

	const meetupData: MeetupData = rawData as MeetupData;
</script>

<Paginate items={meetupData} perPage={10} let:pageItems let:pagination>
	{#each pageItems as meetup}
		<div class="flex">
			<p>{meetup.chapter} &nbsp;</p>
			<p>| {meetup.chapter_city}</p>
		</div>
	{/each}
	{#if pageItems.length > 0}
		<Pagination
			perPageOptions={[5, 10, 50, 100]}
			{pagination}
			show={['perPage', 'pagination', 'prevPage', 'nextPage']}
			classes={{ perPage: 'flex-1 text-right', pagination: 'px-8' }}
		/>
	{/if}
</Paginate>
