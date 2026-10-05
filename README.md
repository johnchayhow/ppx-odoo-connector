# Payment Portal Express — Odoo connector

Adds a **Pay via Portal** button to customer invoices and customers in Odoo. It
opens that invoice in a [Payment Portal Express](https://paymentportalexpress.com)
account, where the customer pays by card or bank transfer, and the payment is
written back to Odoo against the invoice.

Requires a Payment Portal Express account.

## Why there is no Python in here

This is a **data module**: the only Python files are `__manifest__.py` and an
empty `__init__.py`, and everything else is XML records. Odoo Online refuses
modules containing custom Python, and Odoo Online is where most customers' Odoo
lives. Keeping it to data means one module installs everywhere — Odoo Online,
Odoo.sh and on-premise.

The logic is in two `ir.actions.server` records. That code runs inside Odoo's
restricted evaluator, like any server action written through the interface.

## Branches

One branch per Odoo version, which is what the Odoo Apps Store expects:

| Branch | Odoo |
|---|---|
| `19.0` | 19.0 and saas~19.x |

## Installing

**Odoo Online.** Turn on developer mode (Settings → scroll to the bottom →
Developer Tools → Activate), then **Apps → Import Module** (top menu) and upload
a zip of the `ppx_portal` folder.

**Odoo.sh.** Add this repository as a submodule of your project, or copy
`ppx_portal` into your addons, and install from the Apps list.

**On-premise.** Put `ppx_portal` in your addons path, update the apps list, and
install it.

## After installing

1. **Settings → Payment Portal Express → Settings** — set `ppx.tenant_slug` to
   your account's short name from the portal's Accounts page. Leave
   `ppx.portal_host` alone unless you have been given a different address, and
   set `ppx.environment` to `sandbox` while testing.
2. **Settings → Payment Portal Express → Finish setup** — run once. It sets the
   Outstanding Receipts account on each bank journal's manual payment line, and
   creates a payment provider for saved cards to live in. Safe to run again.
3. Open a posted customer invoice → **Pay via Portal**.

## What it adds

| Record | Why |
|---|---|
| `ir.actions.server` ×2 | The invoice and customer buttons' logic |
| `ir.ui.view` ×2 | The buttons themselves, in the form headers |
| `product.product` | "Credit Card Fee", used when a convenience fee is charged |
| `ir.config_parameter` ×3 | Account name, portal address, environment |

Nothing is written to disk, no models are added, and no card data is stored in
or passes through Odoo.

## Licence

LGPL-3. See [LICENSE](LICENSE).
