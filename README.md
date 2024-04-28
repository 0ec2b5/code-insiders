# 🌙 Visual Studio Code Insiders

A Nix flake for conveniently running the latest build of VS Code Insiders. The flake is automatically updated every 24 hours.

## ⚠️ Reproducibility warning

This flake fetches the binary from a non-reproducible source and *will* break on a regular basis, unless the hash is updated. So it is recommended to always run the flake from the latest commit (see below), instead of permanently installing them into your config. 

## 📝 Usage

Simply run the following command in your shell:

```bash
nix run github:0ec2b5/code-insiders
```

