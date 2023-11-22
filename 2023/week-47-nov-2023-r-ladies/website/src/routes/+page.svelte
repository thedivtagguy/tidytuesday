<script>
	import { cubicOut } from 'svelte/easing';
	import { spring } from 'svelte/motion';
	import { geoOrthographic, geoCentroid } from 'd3-geo';
	import { feature } from 'topojson-client';
	import { Chart, Svg, GeoPath, Graticule, Tooltip, Zoom, GeoPoint } from 'layerchart';
	import { cls } from 'svelte-ux';
	import data from './countries-110m.json';
	import meetupData from './meetup-data.json';

	const countries = feature(data, data.objects.countries);

	const springOptions = { stiffness: 0.04 };
	const yaw = spring(0, springOptions);
	const pitch = spring(0, springOptions);
	const roll = spring(0, springOptions);
	const translate = [480, 350];
	const loftedProjection = geoOrthographic()
		.translate(translate)
		.scale(249.5 * 1.3);

	let sensitivity = 75;
	let zoom;
	let scale = 0;
	let selectedFeature;

	$: if (selectedFeature) {
		const centroid = geoCentroid(selectedFeature);
		$yaw = -centroid[0];
		$pitch = -centroid[1];
	}
</script>

<div class="h-[700px] grid relative">
	<Chart
		geo={{
			projection: geoOrthographic,
			fitGeojson: countries,
			rotate: {
				yaw: $yaw,
				pitch: $pitch,
				roll: $roll
			},
			_scale: scale,
			translate: translate
		}}
		tooltip={{ mode: 'manual' }}
		let:tooltip
		let:projection
	>
		<Svg>
			<Zoom
				mode="manual"
				_initialScale={projection.scale()}
				_initialTranslate={{ x: projection.translate()[0], y: projection.translate()[1] }}
				bind:this={zoom}
				scroll="none"
				tweened={{ duration: 800, easing: cubicOut }}
				let:zoomTo
				let:reset={resetZoom}
				on:zoom={(e) => {
					const scale = 250;
					$yaw = e.detail.translate.x * (sensitivity / scale);
					$pitch = -e.detail.translate.y * (sensitivity / scale);
					loftedProjection.rotate([yaw, pitch]);
				}}
			>
				<GeoPath geojson={{ type: 'Sphere' }} class="fill-gray-300 " on:click={() => ($yaw = 0)} />
				<Graticule class="stroke-black/10" />
				{#each countries.features as country}
					<GeoPath
						geojson={country}
						class={cls(
							'fill-gray-400 stroke-slate-100 cursor-pointer',
							selectedFeature === country ? 'fill-red-400' : 'hover:fill-gray-200'
						)}
						on:click={(e) => (selectedFeature = country)}
						{tooltip}
					/>
				{/each}
				<g class="points pointer-events-none">
					{#each meetupData as meetup}
						<GeoPoint lat={meetup.latitude} long={meetup.longitude}>
							<circle r="5" class="fill-white stroke-red-500" />
							<!-- <Text
                y="-6"
                value={capital.description}
                textAnchor="middle"
                class="text-[8px] stroke-white [stroke-width:2px]"
              /> -->
						</GeoPoint>
					{/each}
				</g>
			</Zoom>
		</Svg>

		<Tooltip>
			<div slot="header" let:data>{data.properties.name}</div>
		</Tooltip>
	</Chart>
</div>
