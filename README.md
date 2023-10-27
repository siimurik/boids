# Boids

### Compiled with Zig 0.11.0.

#### Install Zig version 0.11.0 from this [website](https://ziglang.org/download/).

## 1. Extract the Archive:

Open your terminal and navigate to the directory where you downloaded the tar file. Use the cd command to change directories. For example, if the file is in your Downloads folder, you can use:

```
cd ~/Downloads
```

Now, extract the contents of the tar file using the following command:

```
tar -xf zig-linux-x86_64-0.11.0.tar.xz
```

This will create a directory named zig-linux-x86_64-0.11.0 (or similar) containing the Zig executable and related files.

## 2. Move the Zig Directory:

It's a good practice to move the extracted directory to a location where you keep your software. You can use a directory like **/opt/** for this purpose. Use the following command to move the directory:

```
sudo mv zig-linux-x86_64-0.11.0 /opt/
```

This will move the Zig directory to **/opt/**.

## 3. Add Zig to Your Path:

To be able to use Zig from any location in your terminal, you'll need to add it to your system's PATH. Edit your shell's profile file (e.g., **~/.bashrc** for Bash or **~/.zshrc** for Zsh) and add the following line:
```
export PATH="/opt/zig-linux-x86_64-0.11.0:$PATH"
```

Save the file and then source it to apply the changes:


```
source ~/.bashrc  # or source ~/.zshrc if you're using Zsh
```

## 4. Verify the Installation: 

Finally, you can verify that Zig is installed by running:

```
zig version
```

It should output the version of Zig you installed.

```
$ zig version
0.11.0
```

That's it! Zig should now be installed on your system. You can start using it by running zig in your terminal.

## 5. Run the simulation

Go into the folder `boids-main`.

```
cd ~/boids-main
```

And run the command to start the simulation:

```
zig build run
```

---


Requires `stty` for raw mode.

It is recommended to use font which includes dot glyphs.
I use Fira Code with Iosevka as fallback.

![Demo](demo.gif)