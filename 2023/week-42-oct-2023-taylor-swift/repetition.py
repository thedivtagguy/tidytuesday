import gzip
import io

def calculate_repetition_with_compression(lyrics):
    # Convert the lyrics to bytes
    lyrics_bytes = lyrics.encode("utf-8")
    original_size = len(lyrics_bytes)

    # Compress the lyrics using gzip
    buffer = io.BytesIO()
    with gzip.GzipFile(fileobj=buffer, mode="w") as f:
        f.write(lyrics_bytes)
    compressed_size = len(buffer.getvalue())
    
    # Calculate repetition score
    repetition_score = compressed_size / original_size

    return repetition_score

lyrics = "This is a sample lyrics. This is a sample lyrics. This is a sample lyrics. but now this is aomrhing else"
score = calculate_repetition_with_compression(lyrics)
print(f"Repetition Score: {score}")
