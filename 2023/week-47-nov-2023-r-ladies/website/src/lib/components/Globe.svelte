<script lang="ts">
	import { cubicOut } from 'svelte/easing';
	import { spring } from 'svelte/motion';
	import { geoOrthographic } from 'd3-geo';
	import { feature } from 'topojson-client';
	import { Chart, Svg, GeoPath, Zoom, GeoPoint } from 'layerchart';
	import { cls } from 'svelte-ux';
	import { scaleSqrt, max } from 'd3';
	import data from '$lib/data/countries-110m.json';
	import type { MeetupData, MeetupChapter } from '$lib/types';
	import rawData from '$lib/data/output.json';
	import EdgeFade from './EdgeFade.svelte';
	import { selectedChapter, searchMode, keywordChapterList } from '$lib/stores';
	import { getChapterLocation, raiseElement, selectChapter } from '$lib/utils';

	const meetupData: MeetupData = rawData as MeetupData;
	const countries: any = feature(data, data.objects.countries);
	const springOptions = { stiffness: 0.04 };
	const yaw = spring(0, springOptions);
	const pitch = spring(0, springOptions);
	const roll = spring(0, springOptions);
	const rScale = scaleSqrt()
		.domain([0, max(meetupData.map((d) => d.total_events))])
		.range([4, 6]);
	const projection = geoOrthographic().rotate([yaw, pitch, roll]).precision(0.5).clipAngle(90);

	let sensitivity = 75;
	let zoom;
	let scale = 0;

	let selectedFeature: MeetupChapter | undefined;
	let keywordChapters: number[] = [];
	let mode: 'location' | 'topic' = 'location';

	$: if ($selectedChapter.chapter_id) {
		const location = getChapterLocation($selectedChapter.chapter_id, meetupData);

		if (location.latitude && location.longitude) {
			$yaw = -location.longitude;
			$pitch = -location.latitude;
			selectedFeature = meetupData.find((d) => d.chapter_id === $selectedChapter.chapter_id);
		}
	} else {
		selectedFeature = undefined;
	}

	$: if ($keywordChapterList) {
		keywordChapters = $keywordChapterList.map((d) => d.chapter_id);
		if (keywordChapters.length > 0) {
			const location = getChapterLocation(keywordChapters[0], meetupData);
			if (location.latitude && location.longitude) {
				$yaw = -location.longitude;
				$pitch = -location.latitude;
			}
		}
	} else {
		keywordChapters = [];
	}

	$: if ($searchMode === 'topic') {
		mode = 'topic';
		selectedFeature = undefined;
	} else {
		mode = 'location';
		keywordChapters = [];
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
				<radialGradient id="shadow" cx="30%" cy="20%" r="100%">
					<stop offset="0%" style="stop-color: transparent; stop-opacity: 1" />
					<stop offset="50%" style="stop-color: transparent; stop-opacity: 0.5" />
					<stop offset="100%" style="stop-color: black; stop-opacity: 0.4" />
				</radialGradient>
			</defs>

			<Zoom
				mode="manual"
				translateOnScale={false}
				bind:this={zoom}
				tweened={{ duration: 800, easing: cubicOut }}
				on:zoom={(e) => {
					const scale = 250;
					$yaw = e.detail.translate.x * (sensitivity / scale);
					$pitch = -e.detail.translate.y * (sensitivity / scale);
					projection.rotate([yaw, pitch]);
				}}
			>
				<g>
					<GeoPath
						geojson={{ type: 'Sphere' }}
						class="stroke-gray-400 stroke-[0.3px]"
						on:click={() => ($yaw = 0)}
					/>

					{#each countries.features as country}
						<GeoPath
							geojson={country}
							class={cls('fill-[#B2ABBF] stroke-[#ffffff62] stroke-[0.7] cursor-move')}
						/>
					{/each}
					<g class="points">
						{#each meetupData as meetup}
							<EdgeFade
								latitude={meetup.latitude}
								longitude={meetup.longitude}
								geo={projection}
								id={`circle-${meetup.chapter_id}`}
								onRaise={raiseElement}
								shouldRaise={selectedFeature === meetup ||
									keywordChapters.includes(meetup.chapter_id)}
							>
								<GeoPoint lat={meetup.latitude} long={meetup.longitude}>
									<circle
										r={selectedFeature === meetup
											? rScale(meetup.total_events) + 5
											: rScale(meetup.total_events)}
										on:click={() => {
											selectChapter(meetup.chapter_id, meetupData);
											searchMode.set('location');
										}}
										on:keydown={(e) => {
											if (e.key === 'Enter') {
												selectChapter(meetup.chapter_id, meetupData);
												searchMode.set('location');
											}
										}}
										role="button"
										aria-label="Meetup"
										tabindex="-1"
										class="{keywordChapters.includes(meetup.chapter_id)
											? 'fill-[#FF675B] stroke-[#FF675B]'
											: selectedFeature === meetup
											? 'fill-[#F6AA1C] stroke-[#764e05]'
											: 'fill-[#3C6997]/30 stroke-[#5F634F]/30'} transition-all duration-200"
									/>

									<g
										class="pointer-events-none {selectedFeature === meetup ||
										keywordChapters.includes(meetup.chapter_id)
											? 'opacity-100'
											: 'opacity-0'} transition-opacity duration-200 fill-white"
									>
										<text
											opacity="1"
											dy="-15"
											text-anchor="middle"
											fill="#ffffff"
											paint-order="stroke"
											stroke-width="4px"
											stroke-linejoin="round"
											class="text-sm uppercase tracking-wider font-semibold stroke-[#5d5d5d] pointer-events-none"
										>
											{meetup.chapter}
										</text>
									</g>
								</GeoPoint>
							</EdgeFade>
						{/each}
					</g>
				</g>
			</Zoom>
			<GeoPath
				geojson={{ type: 'Sphere' }}
				class="stroke-none pointer-events-none"
				fill="url(#shadow)"
			/>
		</Svg>
	</Chart>
</div>
