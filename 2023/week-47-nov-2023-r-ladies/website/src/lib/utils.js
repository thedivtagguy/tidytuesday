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
