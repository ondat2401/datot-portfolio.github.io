# Dino Run — Asset List

Đặt các file asset vào đúng thư mục dưới đây. Đặt tên file CHÍNH XÁC như liệt kê
(hoặc báo mình nếu muốn đổi tên, mình sẽ chỉnh code cho khớp).

Tất cả sprite nên là **PNG nền trong suốt**, phong cách **pixel-art** để hợp theme retro của site.
Nếu ô nào bạn để trống, mình sẽ tự vẽ phần đó bằng canvas (code) để game vẫn chạy được.

---

## 1. Nhân vật  →  `assets/game/dino/character/`
Bắt buộc (ít nhất phần chạy + nhảy):

| File            | Mô tả                                  | Kích thước gợi ý |
|-----------------|----------------------------------------|------------------|
| `run-1.png`     | Frame chạy 1                           | 64x64 px         |
| `run-2.png`     | Frame chạy 2                           | 64x64 px         |
| `run-3.png`     | Frame chạy 3 (tuỳ chọn)                | 64x64 px         |
| `run-4.png`     | Frame chạy 4 (tuỳ chọn)                | 64x64 px         |
| `jump.png`      | Tư thế nhảy                            | 64x64 px         |
| `duck-1.png`    | Cúi/trượt frame 1 (tuỳ chọn)           | 64x40 px         |
| `duck-2.png`    | Cúi/trượt frame 2 (tuỳ chọn)           | 64x40 px         |
| `dead.png`      | Tư thế game over (tuỳ chọn)            | 64x64 px         |

> Gợi ý: dùng nhân vật mèo của bạn để đồng bộ thương hiệu (nhiều project mèo).

## 2. Chướng ngại vật  →  `assets/game/dino/obstacles/`
Cần ít nhất 1 loại; càng nhiều loại game càng đa dạng:

| File               | Mô tả                                     | Kích thước gợi ý |
|--------------------|-------------------------------------------|------------------|
| `obstacle-1.png`   | Chướng ngại thấp (vd: xương rồng nhỏ)     | 40x60 px         |
| `obstacle-2.png`   | Chướng ngại cao/rộng                      | 60x80 px         |
| `obstacle-3.png`   | Chướng ngại thứ 3 (tuỳ chọn)              | ~50x60 px        |
| `flyer-1.png`      | Chướng ngại bay frame 1 (cần khi có cúi)  | 60x40 px         |
| `flyer-2.png`      | Chướng ngại bay frame 2                    | 60x40 px         |

## 3. Nền & trang trí (TẤT CẢ TUỲ CHỌN — không có mình vẽ code)  →  `assets/game/dino/bg/`

| File           | Mô tả                                       |
|----------------|---------------------------------------------|
| `ground.png`   | Mặt đất, tile lặp ngang (vd rộng 128px)     |
| `cloud.png`    | Mây                                         |
| `mountain.png` | Núi / toà nhà nền (parallax xa)             |

## 4. Âm thanh (TUỲ CHỌN)  →  `assets/game/dino/sfx/`

| File            | Mô tả                    | Định dạng   |
|-----------------|--------------------------|-------------|
| `jump.mp3`      | Tiếng nhảy               | mp3 / wav   |
| `point.mp3`     | Tiếng ăn điểm mốc        | mp3 / wav   |
| `hit.mp3`       | Tiếng va chạm / game over| mp3 / wav   |

---

## Ghi chú
- Sprite chạy nên cùng kích thước để animation mượt.
- Nhân vật nên "chạm đất" ở đáy ảnh (không có khoảng trống thừa phía dưới)
  để canh mặt đất cho chuẩn; nếu có, báo mình offset.
- Sau khi bạn thả asset xong, báo mình tên các file đã có — mình sẽ nối vào game.
- Chưa có asset nào cũng không sao: mình dựng game chạy được bằng pixel-art vẽ code trước,
  rồi thay dần bằng ảnh của bạn.
