<script lang="ts">
	import Globe from '$lib/components/Globe.svelte';
	import Search from '$lib/components/Search.svelte';
	import ChapterCard from '$lib/components/ChapterCard.svelte';
	import Logo from '$lib/images/logo2.png';
</script>

<main class="flex md:flex-row flex-col justify-center items-center w-full">
	<section class="flex flex-col justify-center px-8">
		<div class="flex flex-col justify-center gap-4">
			<div class=" flex flex-col justify-start items-start">
				<div class="avatar">
					<div class="w-28 rounded-xl">
						<img src={Logo} alt="R-Ladies Global" />
					</div>
				</div>
				<div class="prose">
					<h1>R-Ladies Global</h1>
				</div>
			</div>
			<p class="max-w-md">
				R-Ladies is an international initiative committed to fostering gender diversity in the R
				community. Through local meetups, educational workshops, and mentorship programs, R-Ladies
				provides a supportive environment for learning and collaboration. Since its founding in
				2012, the initiative has grown to almost 200 chapters across the world. In most cases, it
				doesn't matter where you live, you can join a meetup in your own city or country, or another
				one that is convenient for you. It is one of the best ways to meet other R users and learn
				from them.
			</p>
		</div>
	</section>
	<section class="globe max-w-[800px] w-full px-4 relative">
		<Globe />
		<div class="datatable py-2 absolute bottom-0 mx-auto w-full">
			<Search />
		</div>
	</section>
	<section class="flex flex-col justify-center px-8 w-full max-w-[500px]">
		<ChapterCard />
	</section>
</main>
