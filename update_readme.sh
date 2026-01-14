#!/bin/bash

# Update README with index of all TidyTuesday weeks

README="README.md"

# Start README
cat > "$README" << 'EOF'
## TidyTuesday Explorations

| Year | Week | Month | Title | Link |
| ---- | ---- | ----- | ----- | ---- |
EOF

# Find all year directories and week subdirectories
for year_dir in */; do
  # Skip if not a directory or doesn't look like a year
  [[ ! -d "$year_dir" ]] && continue
  year=$(basename "$year_dir")
  [[ ! "$year" =~ ^[0-9]{4}$ ]] && continue

  # Find week directories in this year
  for week_dir in "$year_dir"*/; do
    [[ ! -d "$week_dir" ]] && continue

    dirname=$(basename "$week_dir")

    # Parse directory name: week-##-month-year-topic
    if [[ "$dirname" =~ ^week-([0-9]+)-([a-zA-Z]+)-.*$ ]]; then
      week="${BASH_REMATCH[1]}"
      month="${BASH_REMATCH[2]^^}"  # Uppercase month

      # Extract title (everything after month-year)
      title=$(echo "$dirname" | sed -E 's/week-[0-9]+-[a-zA-Z]+-[0-9]+-//' | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')

      # Create link
      link="[${dirname}](./${year}/${dirname})"

      # Add row to table
      echo "| $year | $week | $month | $title | $link |" >> "$README"
    fi
  done
done

echo "README.md updated successfully!"
