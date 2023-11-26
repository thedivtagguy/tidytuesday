<script lang="ts">
	import { timeFormat, timeParse } from 'd3';
	import { getHumanReadableTimeDifference } from '$lib/utils';
	export let meetups: object[];

	function formatDate(dateString: string) {
		const parseDate = timeParse('%Y-%m-%d');
		return timeFormat('%b %Y')(parseDate(dateString));
	}

	// Sort the meetups by date
	meetups.sort((a, b) => new Date(a.date) - new Date(b.date));

	$: total_events = meetups.length;
	$: date_range =
		formatDate(meetups[0].date) + ' - ' + formatDate(meetups[meetups.length - 1].date);
	$: online_events = Math.round(
		(meetups.filter((d) => d.location === 'online').length / total_events) * 100
	);
	$: time_from_last_event = getHumanReadableTimeDifference(meetups);
</script>

<div class="stats m-0 p-0 w-min">
	<div class="stat pl-1 pr-4">
		<div class="stat-title">Total events</div>
		<div class="stat-value">{total_events}</div>
		<div class="stat-desc">{date_range}</div>
		<div class="stat-figure">
			<div
				class="radial-progress text-xs text-center"
				style="--value:{online_events};"
				role="progressbar"
			>
				{online_events}%
				<br /> online
			</div>
		</div>
	</div>

	<div class="stat gap-0">
		<div class="stat-title pb-0 my-0 line-height-0">Last meetup</div>
		<div class="stat-value text-xl py-0">{time_from_last_event}</div>
	</div>
</div>
