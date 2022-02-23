run: clean
	-ln -s ~/.config/.zshrc ~/.zshrc
clean:
	-unlink ~/.zshrc
