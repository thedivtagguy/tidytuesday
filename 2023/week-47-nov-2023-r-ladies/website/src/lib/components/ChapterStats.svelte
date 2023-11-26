<script lang="ts">
	import { timeFormat, timeParse } from 'd3';
	import { getHumanReadableTimeDifference } from '$lib/utils';
	export let meetups: { date: string; location: string }[];

	function formatDate(dateString: string) {
		const parseDate = timeParse('%Y-%m-%d');
		return timeFormat('%b %Y')(parseDate(dateString));
	}

	const parseDate = timeParse('%Y-%m-%d');
	$: meetups = meetups.map((meetup) => ({ ...meetup, parsedDate: parseDate(meetup.date) }));

	$: meetups.sort((a, b) => a.parsedDate - b.parsedDate);

	$: total_events = meetups.length;
	$: date_range =
		formatDate(meetups[0].date) + ' - ' + formatDate(meetups[meetups.length - 1].date);
	$: online_events = Math.round(
		(meetups.filter((d) => d.location === 'online').length / total_events) * 100
	);
	$: time_from_last_event = getHumanReadableTimeDifference(meetups);
</script>

<div class="stats stats-vertical md:stats-horizontal m-0 pb-4 pt-0 w-min">
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

	<div class="stat gap-0 pl-1">
		<div class="stat-title pb-0 my-0 line-height-0">Last meetup</div>
		<div class="stat-value text-xl py-0">{time_from_last_event}</div>
	</div>
</div>
