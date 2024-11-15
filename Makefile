run: clean link-ssh-config
	-ln -s "${PWD}/zshrc" ~/.zshrc
	-ln -s "${PWD}/lein" ~/.lein
	-ln -s "${PWD}/tmux.conf" ~/.tmux.conf
	-ln -s "${PWD}/alacritty" ~/.config/alacritty
	-ln -s "${PWD}/amperity" ~/.config/amperity
	-ln -s "${PWD}/clj-kondo" ~/.config/clj-kondo
	-ln -s "${PWD}/fish" ~/.config/fish
	-ln -s "${PWD}/nvim" ~/.config/nvim
	-ln -s "${PWD}/shadow-cljs" ~/.config/shadow-cljs
	-ln -s "${PWD}/tmuxp" ~/.config/tmuxp
	-ln -s "${PWD}/kitty" ~/.config/kitty
	-ln -s "${PWD}/gitconfig" ~/.gitconfig

ifeq ($(shell uname), Darwin)
link-ssh-config:
	ln -s "${PWD}/ssh-config" ~/.ssh/config
else
link-ssh-config:
	@echo "Skipping SSH config link, not on macOS."
endif

clean:
	-unlink ~/.zshrc
	-unlink ~/.lein
	-unlink ~/.tmux.conf
	-unlink ~/.config/alacritty
	-unlink ~/.config/amperity
	-unlink ~/.config/clj-kondo
	-unlink ~/.config/fish
	-unlink ~/.config/nvim
	-unlink ~/.config/shadow-cljs
	-unlink ~/.config/tmuxp
	-unlink ~/.config/kitty
	-unlink ~/.ssh/config
	-unlink ~/.gitconfig
