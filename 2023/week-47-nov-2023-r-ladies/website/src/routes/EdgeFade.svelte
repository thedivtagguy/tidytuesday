<script lang="ts">
	import { geoDistance } from 'd3-geo';
	import { scaleLinear } from 'd3';

	export let latitude: number;
	export let longitude: number;
	export let geo: any;

	$: fade = scaleLinear().domain([-0.1, 0]).range([0, 1]);
	$: clamper = scaleLinear().domain([0, 1]).range([0, 1]).clamp(true);
	let opacity = 1;

	$: {
		const center = geo.invert(geo.translate());
		const distance = 1.57 - geoDistance([longitude, latitude], center);
		opacity = clamper(fade(distance));
	}
</script>

<g {opacity}>
	<slot />
</g>
