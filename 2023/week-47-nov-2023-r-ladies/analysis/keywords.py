# Description: Extracts top 10 mentions per chapter from the titles of the R-Ladies meetup events
# Author: This was entirely written by ChatGPT, I just added some comments and made some minor changes to make it work with the data
# No way I want to write python myself, so all credit goes to ChatGPT thx bye
import re
import spacy
from spacy.lang.en.stop_words import STOP_WORDS
from collections import Counter
import pandas as pd
from tqdm import tqdm
import random

# Load a pre-trained NER model
nlp = spacy.load("en_core_web_trf")

# Read in the data
data = pd.read_csv('data/data.csv')

# Debug mode - set to True to process only 10 random chapters
DEBUG_MODE = False

# Common terms to exclude
common_terms = {'R', 'Data', 'Session'}

# Regular expression to match unwanted phrases
pattern = re.compile(r"\br[-\s]*ladies\b", re.IGNORECASE)

# Function to filter out irrelevant entity types and extract noun phrases
def extract_relevant_info(text):
    doc = nlp(text)
    relevant_info = []

    # Extract noun phrases and filter out stopwords and unwanted patterns
    for chunk in doc.noun_chunks:
        if chunk.text.lower() not in STOP_WORDS and not pattern.search(chunk.text.lower()):
            relevant_info.append(chunk.text)

    # Extract entities, include specific types, remove stopwords and unwanted patterns
    for ent in doc.ents:
        if ent.label_ in ['NORP', 'FAC', 'ORG', 'LOC', 'PRODUCT', 'WORK_OF_ART'] and \
           ent.text.lower() not in STOP_WORDS and \
           not pattern.search(ent.text.lower()):
            relevant_info.append(ent.text)

    # Further filter out common terms
    relevant_info = [info for info in relevant_info if info.lower() not in common_terms]
    return relevant_info

# If DEBUG_MODE is True, randomly select 10 chapters
if DEBUG_MODE:
    random_chapters = random.sample(set(data['chapter']), 10)
    data = data[data['chapter'].isin(random_chapters)]

# Apply NER to each title with progress bar
tqdm.pandas()
data['relevant_info'] = data['title'].progress_apply(extract_relevant_info)

# Find top 10 mentions for each chapter
info_per_chapter = data.groupby('chapter')['relevant_info'].sum()
top_mentions_per_chapter = info_per_chapter.apply(lambda x: Counter(x).most_common(10))

# Function to format top mentions for CSV output
def format_top_mentions(mentions):
    return ', '.join([word for word, count in mentions])

# Apply formatting to the top mentions
top_mentions_per_chapter_formatted = top_mentions_per_chapter.apply(format_top_mentions)

# Create a new DataFrame for CSV output
output_df = pd.DataFrame({
    'chapter': top_mentions_per_chapter_formatted.index,
    'keywords': top_mentions_per_chapter_formatted.values
})

# Save the results to a CSV file
output_df.to_csv('top_mentions_per_chapter.csv', index=False)

print(output_df.head())
