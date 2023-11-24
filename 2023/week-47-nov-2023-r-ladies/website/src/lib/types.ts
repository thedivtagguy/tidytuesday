export type MeetupEvent = {
    title: string;
    location: string;
    date: string;
  };
  
  export type MeetupChapter = {
    chapter_id: number;
    chapter: string;
    chapter_city: string;
    total_events: number;
    latitude: number;
    longitude: number;
    similar_chapters: number[];
    meetups: MeetupEvent[];
  };
  
  export type MeetupData = MeetupChapter[];

// selectedLocation type
export type SelectedLocation = {
    chapterId: number;
    chapter: string;
};

export type Location = {
    latitude: number | null;
    longitude: number | null;
};