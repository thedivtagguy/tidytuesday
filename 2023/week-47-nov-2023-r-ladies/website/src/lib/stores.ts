import { writable } from 'svelte/store';
import type { MeetupChapter } from './types';

export const userLocation = writable({
	latitude: 0,
	longitude: 0
});

export const selectedLocation = writable({
	chapter_id: 0,
	chapter: '',
	chapter_city: '',
	total_events: 0,
	latitude: 0,
	longitude: 0,
	similar_chapters: [],
	meetups: []
});
