import pandas as pd
import spacy
from collections import defaultdict
from tqdm import tqdm

# Set debug flag
debug_mode = False  # Set to False for full run

# Load your CSV file
df = pd.read_csv('./taylordata.csv')

# Take a smaller sample for debugging, if debug_mode is True
df = df.head(10) if debug_mode else df

# Initialize spaCy NER
nlp = spacy.load('en_core_web_trf')

# Initialize dictionaries to hold the NER information by album
album_ner_entity_dict = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(int))))

# Loop over each row in the DataFrame with a progress bar
for index, row in tqdm(df.iterrows(), total=df.shape[0]):
    album = row['album_name']
    track = row['track_name']
    release_date = row['album_release']
    lyrics = row['lyric']
    
    # Perform NER on the lyrics
    doc = nlp(lyrics)
    
    # Loop over each identified entity
    for ent in doc.ents:
        entity = ent.text
        entity_type = ent.label_
        
        # Increment the count for this specific entity in this album
        album_ner_entity_dict[album][track][entity_type][entity] += 1

# Convert the entity counts to a DataFrame
album_ner_entity_df = pd.DataFrame.from_dict(
    {(album, track, release_date, entity_type, entity): count 
     for album, tracks in album_ner_entity_dict.items()
     for track, entity_types in tracks.items()
     for entity_type, entities in entity_types.items()
     for entity, count in entities.items()},
    orient='index'
)

# Set multi-index for the DataFrame
album_ner_entity_df.index = pd.MultiIndex.from_tuples(album_ner_entity_df.index, names=['Album', 'Track_Name', 'Album_Release', 'Entity_Type', 'Entity'])

# Set column name
album_ner_entity_df.columns = ['Count']

# Save to CSV
csv_file_name = './album_ner_entity_counts_sample.csv' if debug_mode else './album_ner_entity_counts.csv'
album_ner_entity_df.to_csv(csv_file_name)
