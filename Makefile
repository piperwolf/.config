run: clean
	-ln -s ~/.config/.zshrc ~/.zshrc
	-ln -s ~/.config/.lein ~/.lein
	-ln -s ~/.config/.tmux.conf ~/.tmux.conf
clean:
	-unlink ~/.zshrc
	-unlink ~/.lein
	-unlink ~/.tmux.conf
