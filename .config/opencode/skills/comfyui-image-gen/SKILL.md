---
name: comfyui-image-gen
description: Generate or edit images locally with ComfyUI (Z-Image Turbo) on this machine. Use when the user asks to generate, create, draw, illustrate, render, or make a picture/image, or to edit, restyle, recolor, rework, or create variations of an existing image, especially when they mention ComfyUI or Z-Image. Triggers: generate image, create image, text-to-image, txt2img, edit image, image-to-image, img2img, restyle, warmer lighting, image variations, ComfyUI, Z-Image.
---

# ComfyUI image generation (Z-Image Turbo)

## Tool

`/home/jp/ComfyUI/user/default/tools/comfy_gen.py` - Python standard library only,
talks to the local ComfyUI at `http://127.0.0.1:8188`. Run it as:

```
python3 /home/jp/ComfyUI/user/default/tools/comfy_gen.py --mode <txt2img|img2img> ...
```

Key options:
- `--mode txt2img|img2img` (required)
- `--prompt "..."` or `--prompt-file FILE`
- `--input PATH` (required for img2img)
- `--denoise FLOAT` (img2img, default `0.35`)
- `--prefix NAME`, `--steps N` (default 8), `--seed N`, `--cfg FLOAT` (default 1)
- `--width` / `--height` (txt2img, default 1024), `--max-dimension` (img2img, default 768)
- `--timeout SEC` (default 600), `--json`, `--force`

## When to use

- User asks to generate, create, draw, render or make an image -> `txt2img`.
- User asks to edit, restyle, recolor, rework, or make variations of an image, or
  supplies an image as a reference -> `img2img`.
- Requests for "N variations" -> call the tool N times with different `--seed`
  (or omit `--seed` to randomize), reusing the same prompt and input.

## Procedure

1. Choose the mode. Ask a clarification only when an essential detail is missing
   (for example, an image is referenced but none can be found).
2. Find the input image: use the path the user gave, otherwise look in
   `/home/jp/ComfyUI/input/`, `/home/jp/ComfyUI/output/`, `~/Pictures`, or
   `~/Downloads`. If it stays ambiguous, ask which image.
3. Turn the request into a concrete English prompt: subject, style, lighting,
   composition. Match edit strength to intent: small edits ("warmer light",
   "preserve composition") use low denoise (0.2-0.4); strong restyles use 0.5-0.7.
4. Invoke the tool safely. Never interpolate raw prompt text into a shell command
   carelessly. Prefer `--prompt-file` when the prompt contains quotes, `$`,
   backticks, or newlines; otherwise pass `--prompt` in single quotes.
5. Do not start concurrent GPU jobs. The tool refuses to run if another ComfyUI
   job is active, and it stops if Ollama has models loaded on the GPU. If it
   exits with code 3, tell the user what it reported and re-run with `--force`
   only after they confirm.
6. Wait for completion. The tool polls ComfyUI and prints a final line:
   `OUTPUT: <absolute path> (<WxH>, <bytes> bytes)`. Report that exact path.
7. If the tool exits non-zero, quote the error and do not claim success.

## Honest limitations

- Z-Image Turbo `img2img` is a diffusion restyle, not a precise editor. Even at
  low denoise it does not guarantee identity, faces, text, or exact structure
  preservation.
- It cannot reliably perform precise instructed edits such as "remove the hat".
- Image generation is slow and needs the 12 GB GPU; it competes with Ollama.
- Defaults are conservative (img2img longest side 768, txt2img 1024x1024).

## Output

Outputs are written under `/home/jp/ComfyUI/output/` with an incrementing suffix;
existing files are never overwritten. Report the absolute path and dimensions.
