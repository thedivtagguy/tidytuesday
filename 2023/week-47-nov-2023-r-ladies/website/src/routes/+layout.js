import { error } from '@sveltejs/kit';

export async function load() {
	try {
		const post = await import(`../lib/content/Methodology.md`);

		return {
			content: post.default,
			meta: post.metadata
		};
	} catch (e) {
		return error({ status: 404, message: 'Post not found' });
	}
}
