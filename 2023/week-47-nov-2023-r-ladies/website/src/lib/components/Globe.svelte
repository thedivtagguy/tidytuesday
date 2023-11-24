<script lang="ts">
	import { cubicOut } from 'svelte/easing';
	import { spring } from 'svelte/motion';
	import { geoOrthographic, geoCentroid, geoDistance } from 'd3-geo';
	import { feature } from 'topojson-client';
	import { Chart, Svg, GeoPath, Graticule, Zoom, GeoPoint } from 'layerchart';
	import { cls } from 'svelte-ux';
	import { scaleSqrt, max, scaleLinear } from 'd3';
	import data from '$lib/data/countries-110m.json';
	import meetupData from '$lib/data/meetup-data.json';
	import EdgeFade from './EdgeFade.svelte';
	const countries = feature(data, data.objects.countries);

	const springOptions = { stiffness: 0.04 };
	const yaw = spring(0, springOptions);
	const pitch = spring(0, springOptions);
	const roll = spring(0, springOptions);

	const projection = geoOrthographic().rotate([yaw, pitch, roll]).precision(0.1).clipAngle(90);
	let sensitivity = 75;
	let zoom;
	let scale = 0;

	let selectedFeature: any;

	$: if (selectedFeature) {
		const centroid = geoCentroid(selectedFeature);
		$yaw = -centroid[0];
		$pitch = -centroid[1];
	}

	const rScale = scaleSqrt()
		.domain([0, max(meetupData.map((d) => d.total_events))])
		.range([4, 6]);
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
			},
			_scale: scale
		}}
		let:projection
	>
		<Svg>
			<defs>
				<!-- Define radial gradient -->
				<radialGradient id="glowGradient" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
					<stop offset="0%" style="stop-color: white; stop-opacity: 1" />
					<stop offset="100%" style="stop-color: blue; stop-opacity: 0" />
				</radialGradient>

				<!-- Define glow filter -->
				<filter id="glow">
					<feGaussianBlur stdDeviation="5.5" result="coloredBlur" />
					<feMerge>
						<feMergeNode in="coloredBlur" />
						<feMergeNode in="SourceGraphic" />
					</feMerge>
				</filter>
			</defs>

			<!-- <circle r="480" cx={480} cy={580} fill="url(#glowGradient)" filter="url(#glow)" /> -->

			<Zoom
				mode="manual"
				bind:this={zoom}
				scroll="none"
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
				<g class="points pointer-events-none">
					{#each meetupData as meetup}
						<EdgeFade latitude={meetup.latitude} longitude={meetup.longitude} geo={projection}>
							<GeoPoint lat={meetup.latitude} long={meetup.longitude}>
								<circle
									r={rScale(meetup.total_events)}
									class="fill-[#88398A]/50 stroke-[#642965]/40"
								/>
							</GeoPoint>
						</EdgeFade>
					{/each}
				</g>
			</Zoom>
		</Svg>
	</Chart>
</div>
