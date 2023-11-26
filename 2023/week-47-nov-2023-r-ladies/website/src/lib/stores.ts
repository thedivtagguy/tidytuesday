import { writable } from 'svelte/store';
import type { MeetupChapter } from './types';

export const userLocation = writable({
	latitude: 0,
	longitude: 0
});

export const selectedChapter = writable({
	chapter_id: 0,
	chapter: '',
	chapter_city: '',
	total_events: 0,
	latitude: 0,
	longitude: 0,
	similar_chapters: [],
	meetups: []
});

export const selectedKeyword = writable('');

export const keywordChapterList = writable<MeetupChapter[]>([]);

export const searchMode = writable(
	'location' as 'location' | 'topic'
);
