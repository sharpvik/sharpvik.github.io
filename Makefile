fmt:
	elm-format src/

dev:
	elm make src/Main.elm --output dist/js/main.js

prod:
	elm make src/Main.elm --optimize --output dist/js/main.js
	
dist:
	rm ./dist/.gitignore  

release: dist prod
