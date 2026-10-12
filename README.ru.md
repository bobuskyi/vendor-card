# Vendor Card — краткая инструкция

Аддон для **CS-Cart Multi-Vendor** с темой **Responsive**. Основная карточка продавца всегда видна на странице. Дополнительная информация открывается в **Modal** или **Popup**.

## Как установить

1. Скачайте `vendor_card-install.zip` из релиза (не GitHub source ZIP).
2. Откройте **Add-ons → Manage add-ons → Manual installation** и загрузите ZIP; активируйте **Vendor card**.
3. Используйте тему **Responsive** и при необходимости очистите кеш.

**Важно:** это не пакет для **Upgrade Center** (`schema.json` в архиве отсутствует).

## Где добавить блок

Откройте **Design → Layouts**, выберите страницу и контейнер → **Add block → Create new block → Vendor card**. В настройках задайте **Vendor ID**: положительный ID — конкретный продавец, `0` — продавец текущей карточки товара/страницы продавца. На главной странице нужен положительный ID.

## Как переключить Modal / Popup

В настройках блока выберите **Presentation → Modal (CS-Cart)** или **Popup (custom)** и сохраните. Основная карточка остаётся на странице в обоих режимах; кликом открывается только дополнительная информация о продавце.

## Какие механизмы встроенные

**Modal** использует **штатный диалог CS-Cart** (`cm-dialog-opener`, `data-ca-target-id`, `ceDialog`). **Popup** реализован отдельно на JavaScript без сторонних библиотек. Оба используют общий Smarty-компонент `components/vendor_extra.tpl`.

Стили: `var/themes_repository/responsive/css/addons/vendor_card/styles.css`, на установленной витрине — `design/themes/responsive/css/addons/vendor_card/styles.css`. Шаблон основной карточки — `components/vendor_details.tpl`.

**Примечание:** в этой пользовательской версии при отсутствии оценок подставляются демонстрационные `100%` и `4.9`, а не реальные показатели продавца. Для продакшена замените их на нейтральные прочерки; подробности — в `README.md`.
