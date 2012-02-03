find unit/com/* -name '*.hx' -print0 | xargs -0 sed 's/\(import [a-zA-Z.]*\.\*\)/??\1??/'
