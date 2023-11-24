import { writable } from 'svelte/store';

export const userLocation = writable({
	latitude: 0,
	longitude: 0
});
