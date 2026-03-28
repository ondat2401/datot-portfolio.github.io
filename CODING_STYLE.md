# Coding Style Guide

## HTML

- Dùng 2 spaces cho indentation
- Attributes viết lowercase, dùng dấu `"` (double quotes)
- Mỗi section có comment mở đầu: `<!-- Section Name -->`
- Dùng semantic tags: `<section>`, `<nav>`, `<footer>`, `<main>`
- Luôn có `alt` cho `<img>`, `aria-label` cho interactive elements
- Class đặt theo thứ tự: Bootstrap utilities trước, custom class sau

```html
<!-- Good -->
<section id="about" class="py-5 my-custom-section">

<!-- Bad -->
<div id="about" class="my-custom-section py-5">
```

## CSS

- Dùng CSS Variables cho colors, fonts, spacing trong `:root`
- Naming convention: lowercase + hyphen (`skill-card`, `hero-section`)
- Nhóm properties theo thứ tự: layout → box model → typography → visual → misc
- Mỗi component tách block riêng, có comment header
- Không dùng `!important` trừ khi override Bootstrap bắt buộc

```css
/* --- Component Name --- */
.component-name {
  /* layout */
  display: flex;
  position: relative;

  /* box model */
  padding: 1rem;
  margin-bottom: 1rem;

  /* typography */
  font-size: 1rem;
  color: var(--color-dark);

  /* visual */
  background: var(--color-light);
  border-radius: 8px;

  /* misc */
  transition: transform var(--transition-speed);
}
```

## JavaScript

- Dùng `const` mặc định, `let` khi cần reassign, không dùng `var`
- Arrow functions cho callbacks
- Template literals thay string concatenation
- Event listeners gắn trong `DOMContentLoaded`
- Đặt tên biến/hàm: camelCase
- Comment mô tả cho mỗi block logic

```js
// Good
const navLinks = document.querySelectorAll('.nav-link');
navLinks.forEach((link) => {
  link.addEventListener('click', () => { /* ... */ });
});

// Bad
var links = document.getElementsByClassName('nav-link');
```

## File Structure

```
portfolio/
├── index.html
├── assets/
│   ├── css/
│   │   └── style.css       # Custom styles, 1 file chính
│   ├── js/
│   │   └── main.js         # Custom scripts, 1 file chính
│   └── images/             # Ảnh tối ưu, đặt tên lowercase-hyphen
├── pages/                  # Các trang phụ (about.html, blog.html...)
└── CODING_STYLE.md
```

## Quy tắc chung

- Bootstrap classes ưu tiên dùng trước khi viết custom CSS
- Responsive: mobile-first, test ở 3 breakpoints: sm, md, lg
- Không inline styles trừ trường hợp dynamic (JS generate)
- Commit message format: `type: short description` (feat, fix, style, refactor)
- Mỗi section trong HTML tự chứa đủ nội dung, dễ copy/move sang page khác

## Quy tắc với config.json

- `data/config.json` là nguồn dữ liệu chính của toàn bộ site — chứa nội dung user đã nhập
- **KHÔNG ĐƯỢC reset hoặc ghi đè data đã có trong config.json** khi thêm feature mới hoặc sửa cấu trúc
- Khi cần thêm field mới vào config: chỉ thêm field đó vào, giữ nguyên toàn bộ data cũ
- Khi cần đổi cấu trúc: migrate data cũ sang cấu trúc mới, không xóa
- Nếu field mới là optional, để giá trị mặc định `""` hoặc `[]` — code JS phải handle trường hợp field trống/thiếu
