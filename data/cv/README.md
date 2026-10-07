# CV Sources

The English and Chinese CVs share `publications.tex` and `preprints.tex`.

- Compile `main.tex` with pdfLaTeX to generate `../CV.pdf`.
- Compile `main-zh.tex` with XeLaTeX to generate `../CV_zh.pdf`.
- On Overleaf, select the corresponding main document and compiler in Settings.
- Keep full journal citations and compact conference citations here; homepage cards use venue and year only.

Run the selected compiler twice. Fandol fonts are used for portable Chinese rendering.

From the website repository root, run powershell -File data/build-documents.ps1 to rebuild all three PDFs. Requires MiKTeX or TeX Live with pdfLaTeX, XeLaTeX, and Biber.
