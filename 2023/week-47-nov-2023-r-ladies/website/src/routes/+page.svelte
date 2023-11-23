<script lang="ts">
	import { cubicOut } from 'svelte/easing';
	import { spring } from 'svelte/motion';
	import { geoOrthographic, geoCentroid, geoDistance } from 'd3-geo';
	import { feature } from 'topojson-client';
	import { Chart, Svg, GeoPath, Graticule, Tooltip, Zoom, GeoPoint } from 'layerchart';
	import { cls, sortFunc, Button, scrollIntoView } from 'svelte-ux';
	import { scaleSqrt, max, scaleLinear } from 'd3';
	import data from './countries-110m.json';
	import meetupData from './meetup-data.json';
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
		.range([3, 12]);

	let pointData = meetupData;
</script>

<div class="h-[700px] flex relative">
	<div class="overflow-y-scroll overflow-x-hidden scrollbar-none">
		{#each countries.features.sort(sortFunc('properties.name')) as country}
			{@const isSelected = selectedFeature === country}
			<div use:scrollIntoView={{ condition: isSelected }}>
				<Button
					variant={isSelected ? 'fill-light' : 'default'}
					color={isSelected ? 'red' : 'default'}
					class="font-light justify-start"
					fullWidth
					on:click={() => (selectedFeature = country)}
				>
					{country.properties.name}
				</Button>
			</div>
		{/each}
	</div>
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
		tooltip={{ mode: 'manual' }}
		let:tooltip
		let:projection
	>
		<Svg>
			<Zoom
				mode="manual"
				bind:this={zoom}
				scroll="none"
				tweened={{ duration: 800, easing: cubicOut }}
				let:zoomTo
				let:reset={resetZoom}
				on:zoom={(e) => {
					const scale = 650;
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
						class={cls(
							'fill-[#f2f2f2] stroke-[#A5A5A5]/40 cursor-pointer',
							selectedFeature === country ? 'fill-red-400' : 'hover:fill-gray-200'
						)}
						{tooltip}
					/>
				{/each}
				<g class="points pointer-events-none">
					{#each pointData as meetup}
						<EdgeFade latitude={meetup.latitude} longitude={meetup.longitude} geo={projection}>
							<GeoPoint lat={meetup.latitude} long={meetup.longitude}>
								<circle r={rScale(meetup.total_events)} class="fill-[#88398A] stroke-[#642965]" />
							</GeoPoint>
						</EdgeFade>
					{/each}
				</g>
			</Zoom>
		</Svg>

		<Tooltip>
			<div slot="header" let:data>{data.properties.name}</div>
		</Tooltip>
	</Chart>
</div>
