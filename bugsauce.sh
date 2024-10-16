name: Run C++ Code

on:
  push:
    paths:
      - "cpp_code/**"

jobs:
  run-cpp:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Compile and run C++ code
        run: |
          g++ cpp_code/main.cpp -o cpp_code/output
          ./cpp_code/output > cpp_code/output.txt

      - name: Commit result
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add cpp_code/output.txt
          git commit -m "Add C++ output"

      - name: Push result
        uses: ad-m/github-push-action@v0.6.0
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
