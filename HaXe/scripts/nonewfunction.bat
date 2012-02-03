find src/com/* -name *.hx -print0 | xargs -0 sed -i 's/new Function();/null;/'
