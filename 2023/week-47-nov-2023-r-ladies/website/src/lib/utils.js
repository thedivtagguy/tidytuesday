import { selectedChapter, keywordChapterList, selectedKeyword } from '$lib/stores';
import { goto } from '$app/navigation';
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

	const chapterName = extractChapterName(chapter);
	goto(`/?rladies=${encodeURIComponent(chapterName)}`, { noScroll: true });
}

/**
 *
 * @param {string} keyword
 * @param {import("./types").MeetupData} meetupData
 * @returns
 */
export function getChaptersWithKeyword(keyword, meetupData) {
	return meetupData.filter((d) => d.keywords.includes(keyword));
}

/**
 *
 * @param {string} keyword
 * @param {import("./types").MeetupData} meetupData
 * @returns {void}
 */
export function selectKeyword(keyword, meetupData) {
	const chapters = getChaptersWithKeyword(keyword, meetupData);
	keywordChapterList.set(chapters);
	selectedKeyword.set(keyword);
	goto(`/?topic=${encodeURIComponent(keyword)}`, { noScroll: true });
}

/**
 * Get the human readable time difference between now and the last meetup
 * @param {object} meetups
 * @returns {string}
 */
export function getHumanReadableTimeDifference(meetups) {
	const last_meetup = meetups.sort((a, b) => new Date(b.date) - new Date(a.date))[0].date;
	const lastMeetupDate = new Date(last_meetup);
	const today = new Date();
	const diffTime = Math.abs(today.getTime() - lastMeetupDate.getTime());

	const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
	const diffMonths = Math.floor(diffDays / 30);
	const diffYears = Math.floor(diffDays / 365);

	if (diffYears > 0) {
		return diffYears + (diffYears === 1 ? ' year' : ' years') + ' ago';
	} else if (diffMonths > 0) {
		return diffMonths + (diffMonths === 1 ? ' month' : ' months') + ' ago';
	} else {
		return diffDays + (diffDays === 1 ? ' day' : ' days') + ' ago';
	}
}

/**
 * Given a chapter, extract the chapter name
 * @param {object} chapter
 * @returns {string}
 */
export function extractChapterName(chapter, prefix = 'rladies-') {
	if (!chapter || !chapter.chapter) {
		return '';
	}

	const chapterPrefix = prefix.toLowerCase();
	return chapter.chapter.startsWith(chapterPrefix)
		? chapter.chapter.substring(chapterPrefix.length)
		: chapter.chapter;
}
