import os

# Use the current directory as the path
directory_path = os.getcwd()

# Get a list of year directories
year_directories = [d for d in os.listdir(directory_path) if os.path.isdir(os.path.join(directory_path, d))]

# Initialize the README content
readme_content = "## Tidytuesday explorations\n\n"
readme_content += "| Year | Week | Month | Title | Link |\n"
readme_content += "| ---- | ---- | ----- | ----- | ---- |\n"

# Check if README.md already exists, and if it does, read its content
if os.path.exists(os.path.join(directory_path, "README.md")):
    with open(os.path.join(directory_path, "README.md"), "r") as readme_file:
        readme_content = readme_file.read()

# Iterate through the year directories
for year_dir in year_directories:
    # Get a list of subdirectories within the year directory
    subdirectories = [d for d in os.listdir(os.path.join(directory_path, year_dir)) if os.path.isdir(os.path.join(directory_path, year_dir, d))]

    # Iterate through the subdirectories in the year directory
    for subdir in subdirectories:
        parts = subdir.split('-')

        # Check if the subdirectory name follows the expected pattern
        if len(parts) >= 4:
            week = parts[1]
            month = parts[2].upper()
            title_parts = parts[3:]
            # Exclude the year part from the title
            title_parts = [part.capitalize() for part in title_parts if not part.isdigit()]
            title = ' '.join(title_parts)
            link = f"[{subdir}](./{year_dir}/{subdir})"
            
            # Add the row to the table with the year
            readme_content += f"| {year_dir} | {week} | {month} | {title} | {link} |\n"

# Write the README content back to the file
with open(os.path.join(directory_path, "README.md"), "w") as readme_file:
    readme_file.write(readme_content)

print("README.md file updated successfully.")

