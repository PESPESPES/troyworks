find src/com/* -name '*.hx' -print0 | xargs -0 sed -i 's/for[ ]*([ ]*var \([a-zA-Z]*\)[ ]*:[ ]*[A-Z][a-zA-Z]*/for (\1/' 
