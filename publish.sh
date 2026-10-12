#!/bin/bash  

# ./render.sh FORMAT FILE 
# FORMAT = book, slides, or slides_wide
# FILE = all or filename

FORMAT=$1
FILE=$2

if [ "$FORMAT" = "book" ]; then
  echo ""
  echo "Publishing all chapters to gh-pages"
  echo ""
  cp _quarto_book.yml _quarto.yml
  quarto publish gh-pages --no-browser 
  rm _quarto.yml
  rm -r _book
fi

 
if [ "$FORMAT" = "slides" ];  then
  echo ""
	echo "Publishing $FILE to standard slides on quarto-pub"
  echo ""
  cp _quarto_slides.yml _quarto.yml
  quarto publish posit-connect-cloud "$FILE" --no-browser
  rm _quarto.yml
  # rm -r *_files
  # rm *.html
fi
 
if [ "$FORMAT" = "slides_wide" ];  then
  echo ""
	echo "Publishing $FILE to wide slides on quarto-pub"
  echo ""
  cp _quarto_slides_wide.yml _quarto.yml
  quarto publish posit-connect-cloud "$FILE" --no-browser
  rm _quarto.yml
  # rm -r *_files
  # rm *.html
fi
