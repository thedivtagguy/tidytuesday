<script lang="ts">
	import { geoDistance } from 'd3-geo';
	import { scaleLinear, select } from 'd3';

	export let latitude: number;
	export let longitude: number;
	export let geo: any;
	export let id: string;

	$: fade = scaleLinear().domain([-0.1, 0]).range([0, 1]);
	$: clamper = scaleLinear().domain([0, 1]).range([0, 1]).clamp(true);

	let opacity = 1;

	$: {
		const center = geo.invert(geo.translate());
		const distance = 1.57 - geoDistance([longitude, latitude], center);
		opacity = clamper(fade(distance));
	}

	export let onRaise: (id: string) => void;
	export let shouldRaise: boolean;

	// Reactive statement to check for equality
	$: if (shouldRaise) {
		onRaise(id);
	}
</script>

<g {opacity} {id}>
	<slot />
</g>
