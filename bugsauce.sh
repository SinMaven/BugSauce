name: Run Bash Script

on:
  workflow_dispatch:

jobs:
  run-script:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Run the Bash script
      run: |
        # Fixed parameters
        locale="en-US"
        clientfilter="SXC"
        sources="AzureSearch,QuestionAnswering"

        # Prompt user for parameters
        query="${{ github.event.inputs.query }}"
        top="${{ github.event.inputs.top }}"

        # Construct the URL with user input
        url="https://search.support.xboxlive.com/docs?locale=${locale}&query=${query}&top=${top}&sources=$(echo $sources | sed 's/,/%2C/g')&clientfilter=${clientfilter}"

        # Fetch JSON data from the constructed URL using curl
        json_data=$(curl -s "$url")

        # Check if data is successfully retrieved
        if [ -z "$json_data" ]; then
          echo "Failed to retrieve data. Please check the URL and try again."
          exit 1
        fi

        # List all the titles with an index number
        echo "Available Titles:"
        echo "$json_data" | jq -r '.Results[] | "\(.Title)"' | nl
        echo

        # Prompt user to select an index number
        index="${{ github.event.inputs.index }}"

        # Extract the chosen result's details based on the selected index
        selected_result=$(echo "$json_data" | jq --argjson index "$((index-1))" '.Results[$index]')

        # Check if selected_result is empty
        if [ -z "$selected_result" ]; then
          echo "Invalid index. Please check the index number and try again."
          exit 1
        fi

        # Extract the CompassPath
        compass_path=$(echo "$selected_result" | jq -r '.CompassPath')

        # Output the selected details in a professional format
        echo "──────────────────────────────────────────────"
        echo "Selected Title: $(echo "$selected_result" | jq -r '.Title')"
        echo "──────────────────────────────────────────────"
        echo "Description:"
        echo "$(echo "$selected_result" | jq -r '.Description' | sed -e 's/<[^>]*>//g')"
        echo "──────────────────────────────────────────────"
        echo

        # Extract the part after '/SXC'
        path_suffix=$(echo "$compass_path" | sed 's|/Sites/help.ui.xboxlive.com/All||')

        # Construct the full URL for scraping
        full_url="https://content.support.xboxlive.com/content?path=${path_suffix}&language=${locale}&market=US"
        echo "Full URL: $full_url"
        echo

        # Fetch the HTML content from the constructed URL
        html_content=$(curl -s "$full_url")

        # Check if content is successfully retrieved
        if [ -z "$html_content" ]; then
          echo "Failed to retrieve content from $full_url. Please check the URL and try again."
          exit 1
        fi

        # Print all the section headings and their content
        echo "Section Headings:"
        echo "$html_content" | jq -r '
          .ContentList[]?.ContentItem.SectionList[]?.Heading' | nl
        echo

        # Read the section list number from user input
        section_number="${{ github.event.inputs.section_number }}"

        # Validate user input (optional)
        if [[ ! "$section_number" =~ ^[0-9]+$ ]]; then
          echo "Invalid section number. Please enter a non-negative integer."
          exit 1
        fi

        # Extract and format the selected section's content
        echo "──────────────────────────────────────────────"
        echo "$html_content" | jq -r --argjson sn "$section_number" '
          .ContentList[] | 
          select(.ContentItem.SectionList | length > $sn) |
          .ContentItem.SectionList[$sn] | 
          select(.Heading != null and .Heading != "") as $section |
          "Section: \($section.Heading)\n" +
          "──────────────────────────────────────────────\n" +
          ([$section.SectionItems[]? | 
          "Content: \(.HtmlContent // "" | gsub("<[^>]*>"; ""))\n" +
          "URL: \(.Url // "No URL")"] | map(select(. != null and . != "")) | join("\n\n"))' | sed 's/<[^>]*>//g'
        echo "──────────────────────────────────────────────"

    inputs:
      query:
        description: 'The query to search (e.g., subscription)'
        required: true
      top:
        description: 'Number of results to return (e.g., 25)'
        required: true
      index:
        description: 'The number of the title to scrape'
        required: true
      section_number:
        description: 'The section list number'
        required: true
