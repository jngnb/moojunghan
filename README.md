# My Blog

A simple static markdown blog, deployable to GitHub Pages.

## Structure

```
blog/
├── index.html          ← the whole site
├── posts/
│   ├── index.json      ← post manifest (update this when you add posts)
│   ├── hello-world.md
│   └── ...
└── assets/
    └── images/
        └── ...
```

## Adding a Post

1. Write your post as a `.md` file in `posts/`:

```markdown
---
title: My Post Title
date: 2026-07-01
cover: assets/images/my-photo.jpg
---

Your content here...
```

2. Add an entry to `posts/index.json`:

```json
{
  "slug": "my-post-title",
  "title": "My Post Title",
  "date": "2026-07-01",
  "cover": "assets/images/my-photo.jpg"
}
```

3. Add your cover image to `assets/images/`.

4. Commit and push.

## Changing Blog Name / Description

Edit the `BLOG` object at the top of `index.html`:

```javascript
const BLOG = {
  name: "My Blog",
  description: "A place to write things down."
};
```

## GitHub Pages Setup

1. Push this repo to GitHub.
2. Go to repo Settings → Pages.
3. Set source to `main` branch, `/ (root)`.
4. Your blog will be at `https://yourusername.github.io/repo-name/`.

## Markdown Support

- Headings, bold, italic, inline code
- Code blocks with syntax highlighting (via browser default)
- Images: `![alt](assets/images/photo.jpg)`
- Links, blockquotes, lists, horizontal rules
- Korean text works fine
