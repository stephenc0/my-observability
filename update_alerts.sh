#!/bin/bash

# Exit on any error
set -e

# Create required directories
mkdir -p prometheus-config sloth-data

# Check if required files exist
if [ ! -f "sloth-data/slothtemplate.yml" ]; then
    echo "Error: slothtemplate.yml not found in sloth-data directory"
    exit 1
fi

# Generate rules file
echo "Generating rules file..."
if ! docker compose run --rm dsloth generate \
    -i /workdir/sloth-data/slothtemplate.yml \
    -o /workdir/sloth-data/slothrules.yml \
    --sli-plugins-path /workdir/sloth-data/plugins; then
    echo "Error: Failed to generate rules file"
    exit 1
fi

# Verify slothrules.yml was generated
if [ ! -f "sloth-data/slothrules.yml" ]; then
    echo "Error: slothrules.yml was not generated"
    exit 1
fi

# Clear existing rules files
rm -f prometheus-config/rules*.yml

# Process the YAML file and split into individual service files
echo "Splitting slothrules.yml into individual service files..."

awk '
    BEGIN { 
        service = "";
        header = "# Code generated by Sloth (dev): https://github.com/slok/sloth.\n# DO NOT EDIT.\n\ngroups:";
    }
    /^---$/ { 
        if (service != "" && content != "") {
            outfile = sprintf("prometheus-config/%srules.yml", service);
            if (!seen[service]) {
                printf("%s\n", header) > outfile;
                seen[service] = 1;
            }
            printf("%s", content) >> outfile;
        }
        content = "";
        next;
    }
    /sloth_service:/ { 
        service = $2; 
    }
    !/^#/ && !/^$/ {
        if ($0 ~ /^name:/) {
            content = content "- name:" substr($0, 6) "\n";
        } else if ($0 ~ /^rules:/) {
            content = content "  rules:\n";
        } else if ($0 !~ /^groups:/) {
            content = content "  " $0 "\n";
        }
    }
    END {
        if (service != "" && content != "") {
            outfile = sprintf("prometheus-config/%srules.yml", service);
            if (!seen[service]) {
                printf("%s\n", header) > outfile;
            }
            printf("%s", content) >> outfile;
        }
    }
' sloth-data/slothrules.yml

# Get the list of new rule files
rule_filenames=($(ls prometheus-config/*rules.yml 2>/dev/null | xargs -n1 basename | sort))

# Verify files were generated
if [ ${#rule_filenames[@]} -eq 0 ]; then
    echo "Error: No rule files were generated"
    exit 1
fi

echo "Generated rule files:"
printf '%s\n' "${rule_filenames[@]}"

# Create temporary file for prometheus.yml update
tmp_file=$(mktemp)

# Update prometheus.yml while preserving other content
{
    # Copy everything up to rule_files section
    sed -n '1,/^rule_files:/p' prometheus-config/prometheus.yml | sed '$d'

    # Add updated rule_files section
    echo "rule_files:"
    for filename in "${rule_filenames[@]}"; do
        echo "  - ${filename}"
    done
} > "$tmp_file"

# Move temporary file to replace original
mv "$tmp_file" prometheus-config/prometheus.yml

echo "Configuration files updated successfully."

# Restart Prometheus container to apply new rules
echo "Restarting Prometheus to apply new rules..."
if ! docker compose restart prometheus; then
    echo "Error: Failed to restart Prometheus"
    exit 1
fi

echo "Prometheus container restarted successfully."

rm sloth-data/slothrules.yml
echo "Removed temp files"
