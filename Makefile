dev:
	elm make --output ./dist/js/main.js ./src/Main.elm 

prod:
	elm make --optimize --output ./dist/js/main.js ./src/Main.elm
	