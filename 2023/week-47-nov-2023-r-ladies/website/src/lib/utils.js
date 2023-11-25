import { selectedChapter } from '$lib/stores';
/**
 * Given a chapter id and data, return the latitude and longitude of the chapter in the data
 * @param {number} chapterId
 * @param {import("./types").MeetupData} data
 * @returns {import("./types").Location} location
 *
 */
export function getChapterLocation(chapterId, data) {
	const chapter = data.find((chapter) => chapter.chapter_id === chapterId);

	if (chapter) {
		return {
			latitude: chapter.latitude,
			longitude: chapter.longitude
		};
	}

	return { latitude: null, longitude: null };
}

/**
 * Given an id, raise the element to the top of the svg tree
 * @param {string} id
 */
export function raiseElement(id) {
	const element = document.getElementById(id);
	if (element?.parentNode) {
		element.parentNode.appendChild(element);
	}
}

/**
 * Given a chapter id, select the chapter and set the selectedChapter store
 * @param {number} chapterId
 * @param {import("./types").MeetupData} meetupData
 *
 * @returns {void}
 */
export function selectChapter(chapterId, meetupData) {
	const chapter = meetupData.find((d) => d.chapter_id === chapterId);
	if (chapter) {
		selectedChapter.set(chapter);
	}
}
