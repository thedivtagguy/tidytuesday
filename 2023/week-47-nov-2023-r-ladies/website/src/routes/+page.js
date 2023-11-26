export const prerender = true;
import meetupData from '$lib/data/output.json';
import { selectedChapter } from '$lib/stores';
import { extractChapterName } from '$lib/utils.js';

export const load = async ({ url }) => {
	const chapter = url.searchParams.get('rladies');
	const chapterData = meetupData.find((d) => d.chapter === 'rladies-' + chapter);
	if (chapterData) {
		selectedChapter.set(chapterData);
		return {
			status: 200,
			body: {
				chapter: chapterData
			}
		};
	}
};
