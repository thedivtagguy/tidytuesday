<script lang="ts">
	import { userLocation } from '$lib/stores';

	enum ButtonState {
		Initial = 'Find chapters near me',
		Fetching = 'Getting your location...',
		Success = 'Gotcha!'
	}

	let buttonState: ButtonState = ButtonState.Initial;
	let coords: [longitude: number, latitude: number] = [0, 0];
	let city: string;

	const options = {
		enableHighAccuracy: false,
		timeout: 10000,
		maximumAge: 10000
	};

	$: if (coords[0] !== 0 && coords[1] !== 0) {
		userLocation.set({
			latitude: coords[1],
			longitude: coords[0]
		});
		reverseGeocode(coords[1], coords[0]);
		buttonState = ButtonState.Success;
	}

	function getLocation() {
		buttonState = ButtonState.Fetching;
		navigator.geolocation.getCurrentPosition(
			(position) => {
				coords = [position.coords.longitude, position.coords.latitude];
			},
			() => {
				buttonState = ButtonState.Initial;
			},
			options
		);
	}

	async function reverseGeocode(latitude: number, longitude: number) {
		const response = await fetch(
			`https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`
		);
		console.log(response);
		if (response.ok) {
			const data = await response.json();
			city = data.address.city || data.address.town || data.address.village;
		}
	}
</script>

<button
	class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
	on:click={getLocation}
	disabled={buttonState !== ButtonState.Initial}
>
	{buttonState}
</button>

{#if city}
	<p>Your city: {city}</p>
{/if}
