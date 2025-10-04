#!/bin/bash
# batch-process.sh - สร้างรูป 3 ขนาด + extract links

OUTPUT_DIR="batch"
mkdir -p "$OUTPUT_DIR"

for pdf in *.pdf; do
    if [ ! -f "$pdf" ]; then
        continue
    fi
    
    name=$(basename "$pdf" .pdf)
    base_dir="$OUTPUT_DIR/$name"
    
    thumb_dir="$base_dir/thumbnails"
    low_dir="$base_dir/low"
    high_dir="$base_dir/high"
    
    mkdir -p "$thumb_dir" "$low_dir" "$high_dir"
    
    echo "Processing: $pdf"
    echo "Creating thumbnails..."
    
    # Thumbnails (200px width)
    pdftoppm -jpeg -r 72 -scale-to 200 "$pdf" "$thumb_dir/page" >/dev/null 2>&1
    
    echo "Creating low resolution..."
    
    # Low resolution (800px width) 
    pdftoppm -jpeg -r 72 -scale-to 800 "$pdf" "$low_dir/page" >/dev/null 2>&1
    
    echo "Creating high resolution..."
    
    # High resolution (1600px width)
    pdftoppm -jpeg -r 72 -scale-to 1600 "$pdf" "$high_dir/page" >/dev/null 2>&1
    
    thumb_files=($(ls "$thumb_dir"/*.jpg 2>/dev/null | sort))
    low_files=($(ls "$low_dir"/*.jpg 2>/dev/null | sort))
    high_files=($(ls "$high_dir"/*.jpg 2>/dev/null | sort))
    
    # Create JSON base
    JSON_FILE="$base_dir/index.json"
    
    {
        echo "{"
        echo "  \"title\": \"${name}\","
        echo "  \"totalPages\": ${#thumb_files[@]},"
        
        # Thumbnails 
        echo -n "  \"thumbnails\": ["
        for i in "${!thumb_files[@]}"; do
            if [ $i -gt 0 ]; then echo -n ", "; fi
            # ใช้ relative path จาก batch folder
            rel_path="${thumb_files[$i]#$OUTPUT_DIR/}"
            echo -n "\"$rel_path\""
        done
        echo "],"
        
        # Low resolution 
        echo -n "  \"low\": ["
        for i in "${!low_files[@]}"; do
            if [ $i -gt 0 ]; then echo -n ", "; fi
            rel_path="${low_files[$i]#$OUTPUT_DIR/}"
            echo -n "\"$rel_path\""
        done
        echo "],"
        
        # High resolution 
        echo -n "  \"high\": ["
        for i in "${!high_files[@]}"; do
            if [ $i -gt 0 ]; then echo -n ", "; fi
            rel_path="${high_files[$i]#$OUTPUT_DIR/}"
            echo -n "\"$rel_path\""
        done
        echo "],"
        
        # Links placeholder 
        echo "  \"links\": []"
        echo "}"
    } > "$JSON_FILE"
    
    echo "Extracting links..."
    
    # Node.js script for extract links
    if command -v node &> /dev/null; then
        node extract-links.js "$pdf" "$JSON_FILE"
        if [ $? -eq 0 ]; then
            echo " Links extracted"
        else
            echo "Failed to extract links"
        fi
    else
        echo "Node.js not found, skipping links extraction"
    fi
    
    echo "Completed: $pdf"
    echo "  -Output: $base_dir/"
    echo "---"
done

echo ""
echo "All PDFs processed!"
echo "Output structure:"
echo "  $OUTPUT_DIR/"
echo "    └── [PDF_NAME]/"
echo "        ├── index.json"
echo "        ├── thumbnails/"
echo "        ├── low/"
echo "        └── high/"