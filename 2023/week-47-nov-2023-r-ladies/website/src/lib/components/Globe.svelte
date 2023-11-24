<script lang="ts">
	import { cubicOut } from 'svelte/easing';
	import { spring } from 'svelte/motion';
	import { geoOrthographic, geoCentroid } from 'd3-geo';
	import { feature } from 'topojson-client';
	import { Chart, Svg, GeoPath, Graticule, Zoom, GeoPoint } from 'layerchart';
	import { cls } from 'svelte-ux';
	import { scaleSqrt, max } from 'd3';
	import data from '$lib/data/countries-110m.json';
	import type { MeetupData, MeetupChapter } from '$lib/types.ts';
	import rawData from '$lib/data/output.json';
	import EdgeFade from './EdgeFade.svelte';
	import { selectedLocation } from '$lib/stores';
	import { getChapterLocation } from '$lib/utils';

	const meetupData: MeetupData = rawData as MeetupData;

	const countries: any = feature(data, data.objects.countries);
	const springOptions = { stiffness: 0.04 };
	const yaw = spring(0, springOptions);
	const pitch = spring(0, springOptions);
	const roll = spring(0, springOptions);
	const rScale = scaleSqrt()
		.domain([0, max(meetupData.map((d) => d.total_events))])
		.range([4, 6]);
	const projection = geoOrthographic().rotate([yaw, pitch, roll]).precision(0.1).clipAngle(90);

	let sensitivity = 75;
	let zoom;
	let scale = 0;

	let selectedFeature: MeetupChapter | undefined;
	let hoverFeature: MeetupChapter | undefined;

	$: if ($selectedLocation.chapterId) {
		const location = getChapterLocation($selectedLocation.chapterId, meetupData);

		if (location.latitude && location.longitude) {
			$yaw = -location.longitude;
			$pitch = -location.latitude;
		}
		selectedFeature = meetupData.find((d) => d.chapter_id === $selectedLocation.chapterId);
	} else {
		selectedFeature = undefined;
	}
</script>

<div class="h-[700px] flex relative">
	<Chart
		geo={{
			projection: geoOrthographic,
			fitGeojson: countries,
			rotate: {
				yaw: $yaw,
				pitch: $pitch,
				roll: $roll
			}
		}}
		let:projection
	>
		<Svg>
			<defs>
				<radialGradient id="glowGradient" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
					<stop offset="0%" style="stop-color: white; stop-opacity: 1" />
					<stop offset="100%" style="stop-color: blue; stop-opacity: 0" />
				</radialGradient>

				<filter id="glow">
					<feGaussianBlur stdDeviation="5.5" result="coloredBlur" />
					<feMerge>
						<feMergeNode in="coloredBlur" />
						<feMergeNode in="SourceGraphic" />
					</feMerge>
				</filter>
			</defs>

			<circle
				cx="50%"
				cy="50%"
				r="70%"
				fill="url(#glowGradient)"
				filter="url(#glow)"
				opacity="0.5"
			/>
			<Zoom
				mode="manual"
				bind:this={zoom}
				scroll="none"
				translateOnScale={false}
				tweened={{ duration: 800, easing: cubicOut }}
				let:zoomTo
				let:reset={resetZoom}
				on:zoom={(e) => {
					const scale = 250;
					$yaw = e.detail.translate.x * (sensitivity / scale);
					$pitch = -e.detail.translate.y * (sensitivity / scale);
					projection.rotate([yaw, pitch]);
				}}
			>
				<GeoPath
					geojson={{ type: 'Sphere' }}
					class="fill-[#dadada] stroke-purple-50"
					on:click={() => ($yaw = 0)}
				/>

				<Graticule class="stroke-black/5" />
				{#each countries.features as country}
					<GeoPath
						geojson={country}
						class={cls('fill-[#f2f2f2] stroke-[#A5A5A5]/40 cursor-pointer')}
					/>
				{/each}
				<g class="points">
					{#each meetupData as meetup}
						<EdgeFade latitude={meetup.latitude} longitude={meetup.longitude} geo={projection}>
							<GeoPoint lat={meetup.latitude} long={meetup.longitude}>
								<circle
									r={selectedFeature === meetup
										? rScale(meetup.total_events) + 2
										: rScale(meetup.total_events)}
									on:mouseover={() => (hoverFeature = meetup)}
									on:mouseout={() => (hoverFeature = undefined)}
									on:focus={() => (hoverFeature = meetup)}
									on:blur={() => (hoverFeature = undefined)}
									role="button"
									aria-label="Meetup"
									tabindex="-1"
									class="
									{selectedFeature === undefined
										? 'fill-[#88398A]/50 stroke-[#642965]/40  transition-all duration-200'
										: selectedFeature === meetup
										? 'fill-[#88398A] stroke-[#642965] animate-pulse transition-all duration-200'
										: 'fill-[#575757]/20 stroke-[#e2e2e2]  transition-all duration-200'}
									
									"
								/>
								<text
									opacity={hoverFeature === meetup ? 1 : 0}
									dy="-15"
									dx="-40"
									class="fill-[#642965] text-sm
									uppercase font-medium pointer-events-none"
									transform="translate(0, 5)">{meetup.chapter}</text
								>
							</GeoPoint>
						</EdgeFade>
					{/each}
				</g>
			</Zoom>
		</Svg>
	</Chart>
</div>
