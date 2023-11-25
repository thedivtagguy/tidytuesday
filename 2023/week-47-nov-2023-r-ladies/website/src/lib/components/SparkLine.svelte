<script lang="ts">
	import { Chart, Svg, Tooltip, Spline, Highlight, Axis, LinearGradient } from 'layerchart';
	import {
		scaleTime,
		timeFormat,
		timeMonth,
		scaleSequential,
		ticks,
		extent,
		interpolatePurples,
		curveBumpX
	} from 'd3';
	import meetupData from '$lib/data/output.json';

	export let chapter_id: number | undefined;

	$: chapterData = meetupData.find((d) => d.chapter_id === chapter_id);

	let data = [];
	$: if (chapterData && chapterData.meetups) {
		const counts = {};
		let minDate = new Date(chapterData.meetups[0].date);
		let maxDate = new Date(chapterData.meetups[0].date);

		// Aggregate counts and find date range in a single iteration
		chapterData.meetups.forEach((d) => {
			const date = new Date(d.date);
			const month = timeMonth(date).toISOString();
			counts[month] = (counts[month] || 0) + 1;
			if (date < minDate) minDate = date;
			if (date > maxDate) maxDate = date;
		});

		// Create timeline and map it to data
		let currentDate = timeMonth.floor(minDate);
		data = [];
		while (currentDate <= maxDate) {
			const month = currentDate.toISOString();
			data.push({ date: new Date(currentDate), value: counts[month] || 0 });
			currentDate = timeMonth.offset(currentDate, 1);
		}
	}

	$: frequencyColor = scaleSequential(
		extent(data, (d) => d.value),
		['#4C4FB7', '#8A57CB', '#DC70E8']
	);

	const formatDate = timeFormat('%b, %Y');
</script>

<div class="w-[125px] h-[25px]">
	<Chart {data} x="date" xScale={scaleTime()} y="value" tooltip let:containerHeight>
		<Svg>
			<LinearGradient
				stops={ticks(0, 5, 2).reverse().map(frequencyColor.interpolator())}
				vertical
				let:url
			>
				<Spline class="stroke-2" stroke={url} curve={curveBumpX} />
			</LinearGradient>
			<Highlight points={{ r: 3, class: 'stroke-none' }} />
		</Svg>

		<Tooltip class="text-xs w-fit flex" contained={false} variant="none" y={-40} let:data
			><div class="font-semibold w-full">
				<span>
					{data.value}
					{data.value === 1 ? 'meetup' : 'meetups'}
				</span>
			</div>
			<div class="whitespace-nowrap">
				{formatDate(data.date)}
			</div>
		</Tooltip>
	</Chart>
</div>
