export const prerender = true;
import meetupData from '$lib/data/output.json';
import { selectedChapter, selectedKeyword, searchMode } from '$lib/stores';

export const load = async ({ url }) => {
	const chapter = url.searchParams.get('rladies');
	const keyword = url.searchParams.get('topic');
	const chapterData = meetupData.find((d) => d.chapter === 'rladies-' + chapter);
	if (chapterData) {
		selectedChapter.set(chapterData);
		searchMode.set('location');
		return {
			status: 200
		};
	}

	if (keyword) {
		selectedKeyword.set(keyword);
		searchMode.set('topic');
		return {
			status: 200
		};
	}
};
