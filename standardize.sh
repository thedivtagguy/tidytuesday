#!/bin/bash

# Standardize all TidyTuesday week directories and output files

set -e

# Function to get month abbreviation from week number
get_month() {
  local week=$1
  if [[ $week -ge 1 && $week -le 4 ]]; then echo "jan"
  elif [[ $week -ge 5 && $week -le 8 ]]; then echo "feb"
  elif [[ $week -ge 9 && $week -le 13 ]]; then echo "mar"
  elif [[ $week -ge 14 && $week -le 17 ]]; then echo "apr"
  elif [[ $week -ge 18 && $week -le 21 ]]; then echo "may"
  elif [[ $week -ge 22 && $week -le 26 ]]; then echo "jun"
  elif [[ $week -ge 27 && $week -le 30 ]]; then echo "jul"
  elif [[ $week -ge 31 && $week -le 35 ]]; then echo "aug"
  elif [[ $week -ge 36 && $week -le 39 ]]; then echo "sept"
  elif [[ $week -ge 40 && $week -le 44 ]]; then echo "oct"
  elif [[ $week -ge 45 && $week -le 48 ]]; then echo "nov"
  else echo "dec"
  fi
}

# Process each year directory
for year_dir in */; do
  [[ ! -d "$year_dir" ]] && continue
  year=$(basename "$year_dir")
  [[ ! "$year" =~ ^[0-9]{4}$ ]] && continue

  echo "Processing year: $year"

  # Process each week directory
  for week_dir in "$year_dir"*/; do
    [[ ! -d "$week_dir" ]] && continue

    old_dirname=$(basename "$week_dir")

    # Extract week number from directory name
    if [[ "$old_dirname" =~ week-([0-9]+) ]]; then
      week="${BASH_REMATCH[1]}"

      # Check if already in correct format (week-##-month-year-topic)
      if [[ "$old_dirname" =~ ^week-[0-9]+-[a-zA-Z]+-[0-9]{4}-.+$ ]]; then
        echo "  ✓ $old_dirname (already standardized)"
        new_dirname="$old_dirname"
      else
        # Determine month and extract topic
        if [[ "$old_dirname" =~ ^week-[0-9]+-([a-zA-Z]+)-([0-9]{4})-(.+)$ ]]; then
          # Already has month and year: week-##-month-year-topic
          month="${BASH_REMATCH[1]}"
          topic="${BASH_REMATCH[3]}"
        elif [[ "$old_dirname" =~ ^week-[0-9]+-([a-zA-Z]+)-(.+)$ ]]; then
          # Has month but no year: week-##-month-topic
          month="${BASH_REMATCH[1]}"
          topic="${BASH_REMATCH[2]}"
        else
          # No month: week-##-topic
          month=$(get_month "$week")
          topic=$(echo "$old_dirname" | sed -E 's/^week-[0-9]+-//')
        fi

        # Build new directory name
        new_dirname="week-${week}-${month}-${year}-${topic}"

        # Rename directory if needed
        if [[ "$old_dirname" != "$new_dirname" ]]; then
          echo "  → Renaming: $old_dirname -> $new_dirname"
          mv "${year_dir}${old_dirname}" "${year_dir}${new_dirname}"
        else
          echo "  ✓ $old_dirname (already correct)"
        fi
      fi

      # Standardize output file to plot.png
      output_dir="${year_dir}${new_dirname}/output"
      if [[ -d "$output_dir" ]]; then
        # Check if plot.png already exists
        if [[ -f "$output_dir/plot.png" ]]; then
          echo "    ✓ plot.png exists"
        else
          # Find first PNG/JPG file and rename it to plot.png
          first_image=$(find "$output_dir" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) 2>/dev/null | head -1)
          if [[ -n "$first_image" ]]; then
            echo "    → Creating plot.png from $(basename "$first_image")"
            cp "$first_image" "$output_dir/plot.png"
          else
            echo "    ⚠ No image found in output directory"
          fi
        fi
      else
        echo "    ⚠ No output directory found"
      fi
    fi
  done
done

echo ""
echo "Standardization complete!"
