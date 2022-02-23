run: clean
	-ln -s ~/.config/.zshrc ~/.zshrc
	-ln -s ~/.config/.lein ~/.lein
clean:
	-unlink ~/.zshrc
	-unlink ~/.lein
