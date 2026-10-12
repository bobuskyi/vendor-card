# Vendor Card — CS-Cart Multi-Vendor add-on

A responsive, always-visible vendor profile for the **Responsive** storefront theme. Clicking the profile opens additional vendor details in either a **native CS-Cart modal** or a **custom anchored popup**.

**Target:** CS-Cart Multi-Vendor 4.18.1+ (declared in `addon.xml`); developed and manually tested on a local **4.21.2** installation. Compatibility and appearance should be tested in your own target version and theme.

## Install

1. Download the release install ZIP (`vendor_card-install.zip`), **not** this GitHub source ZIP.
2. In CS-Cart administration open **Add-ons → Manage add-ons → Manual installation** (the menu label may vary by version), upload the install ZIP and enable **Vendor card**.
3. Make sure the **Responsive** theme is active. Clear the CS-Cart cache if the block or styles do not appear.

**Do not upload the ZIP via Upgrade Center:** it expects a different package type with `schema.json`.

Alternatively, copy this repository's `app/`, `js/`, and `var/` directories into the CS-Cart installation root, merging directories, then install/enable the add-on in admin. For an existing local install, active templates/styles may also need to be synchronized from `var/themes_repository/responsive/` to `design/themes/responsive/` and the cache cleared. Avoid deleting a configured add-on just to refresh its files.

## Add the block

1. Open **Design → Layouts** and choose a page/container (for example, the homepage).
2. Click **Add block → Create new block → Vendor card**; choose the **Vendor card** template and save.
3. Set **Vendor ID** (`vendor_card_company_id`): a **positive ID** displays that vendor on any page; **0** automatically reads the current vendor or product page. On the homepage, use a positive ID because there is no vendor context.
4. Set **Presentation** (`vendor_card_mode`) to **Modal (CS-Cart)** or **Popup (custom)**. Save and reload the storefront.

The full profile (avatar, name, plan, metadata, description, and statistics) is displayed **in the default page block**. Clicking the cover opens *supplementary* vendor information (full description, location, website, storefront link). Changing the Presentation setting does not move the profile into a popup.

## Built-in vs. custom UI

- **Modal** (`components/vendor_modal.tpl`, `js/addons/vendor_card/modal.js`) uses **CS-Cart's built-in dialog**: `cm-dialog-opener`, `cm-dialog-auto-size`, `data-ca-target-id`, and `ceDialog`. The JavaScript adapts focus/backdrop handling; it does not replace the native modal framework.
- **Popup** (`components/vendor_popup.tpl`, `js/addons/vendor_card/popup.js`) is a **custom accessible nonmodal popup**. It handles anchoring, viewport changes, outside-click, Escape, focus, and AJAX reinitialization; no third-party popup library is bundled.
- Both modes share the same content in `components/vendor_extra.tpl` and the same data model in `app/addons/vendor_card/func.php`.

## Files and customization

| File | Responsibility |
| --- | --- |
| `app/addons/vendor_card/addon.xml` | Add-on identity and compatibility |
| `app/addons/vendor_card/schemas/block_manager/blocks.post.php` | Block registration and mode/vendor settings |
| `app/addons/vendor_card/func.php` | Vendor data, metrics and fallbacks |
| `var/themes_repository/responsive/templates/addons/vendor_card/blocks/entry.tpl` | Block entry point |
| `.../components/vendor_details.tpl` | Always-visible profile markup |
| `.../components/vendor_extra.tpl` | Content of Modal and Popup |
| `var/themes_repository/responsive/css/addons/vendor_card/styles.css` | All component styling |
| `js/addons/vendor_card/` | Modal/popup behavior and avatar fallback |
| `var/langs/{en,uk,ru}/addons/vendor_card.po` | Language strings |

When developing an installed Responsive theme, edit `design/themes/responsive/templates/addons/vendor_card/` and `design/themes/responsive/css/addons/vendor_card/styles.css`, and copy those edits back to the **repository locations above** before rebuilding the install ZIP. Use `bash scripts/build-addon-zip.sh` to produce `dist/vendor_card-install.zip` from this repository.

## Data and demo fallbacks

Vendor information is read from CS-Cart. Optional KYC, online status and response time are shown as unavailable unless explicitly supplied by an external/local demo fixture. When available, approved seller ratings and completed orders are queried from the database; missing values are not necessarily equivalent to zero. The optional local fixture `var/files/vendor_card/demo_profile.json` is **not** included in this repository.

**Important demo-only behavior in this customized version:** in `components/vendor_details.tpl`, missing `positive_percent` displays a **hard-coded `100%`** and missing `rating` displays a **hard-coded `4.9`**. These are *visual placeholders*, **not actual CS-Cart vendor metrics**; the data model still returns missing metrics as `null`. Replace both fallbacks with `—` before using this add-on for real vendor statistics or presenting the card as production-ready. The included test version preserves the author's custom markup as supplied.

`.po` file edits do not automatically update language strings already installed into CS-Cart's database. Change live translations via **Administration → Languages → Translations** or re-import translations using the administration workflow.

## Publishing to GitHub

Extract the GitHub source ZIP into an empty folder, then run:

```bash
git init -b main
git add .
git commit -m "Add Vendor Card for CS-Cart Multi-Vendor"
gh auth login                       # only if not already authenticated
gh repo create vendor-card --public --source=. --remote=origin --push
```

After publication, provide the actual link shown by `gh repo view --web` (for example, `https://github.com/<username>/vendor-card`). This source archive is **not itself a published GitHub repository**.
