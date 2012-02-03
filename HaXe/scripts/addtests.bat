find unit/com/* -name '*.hx' -print0 | xargs -0 sed -i 's/\(public function\)/@Test \n\t\1 /'
